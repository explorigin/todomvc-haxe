package todomvc;

// Import standard library tools
import js.Browser.*;
import js.html.Element;
import haxe.Template;

// Here we include JQueryExtern definitions
import jQuery.*;

// Use _[Static Extension](http://haxe.org/manual/lf-static-extension.html)_ for Strings and Arrays
using StringTools;
using Lambda;


/**
    App represents the main scope of our application.
**/
class App {
    var store:todomvc.Store<Todo>;
    var filter = 'all';
    var todos:Array<Todo>;

    static inline var ENTER_KEY = 13;
    static inline var ESCAPE_KEY = 27;

    var _todoApp:JQuery;
    var _header:JQuery;
    var _main:JQuery;
    var _footer:JQuery;
    var _newTodo:JQuery;
    var _toggleAll:JQuery;
    var _todoList:JQuery;
    var _count:JQuery;
    var _clearBtn:JQuery;

    var todoTemplate = new Template('<li data-id="::id::" class="::completed::">
        <div class="view">
            <input class="toggle" type="checkbox" ::checked::>
            <label>::title::</label>
            <button class="destroy"></button>
        </div>
        <input class="edit" value="::title::">
    </li>');

    var footerTemplate = new Template('<span id="todo-count"><strong>::activeTodoCount::</strong> ::activeTodoWord:: left</span>
        <ul id="filters">
            <li>
                <a ::if (filter == "all")::class="selected"::end:: href="#/all">All</a>
            </li>
            <li>
                <a ::if (filter == "active")::class="selected" ::end::href="#/active">Active</a>
            </li>
            <li>
                <a ::if (filter == "completed")::class="selected" ::end::href="#/completed">Completed</a>
            </li>
        </ul>
        ::if completedTodos::<button id="clear-completed">Clear completed (::completedTodos::)</button>::end::');

    public function new(name:String) {
        store = new Store<Todo>(name);
        todos = store.findAll();

        cacheElements();
        bindEvents();
    }

    public function cacheElements() {
        _todoApp = new JQuery('#todoapp');
        _header = _todoApp.find('#header');
        _main = _todoApp.find('#main');
        _footer = _todoApp.find('#footer');
        _newTodo = _header.find('#new-todo');
        _toggleAll = _main.find('#toggle-all');
        _todoList = _main.find('#todo-list');
        _count = _footer.find('#todo-count');
        _clearBtn = _footer.find('#clear-completed');
    }

    public function bindEvents() {
        _newTodo.on('keyup', onNewTodoKeyUp);
        _toggleAll.on('change', onToggleAllChange);
        _footer.on('click', '#clear-completed', onClearClick);

        _todoList.on('change', '.toggle', onToggleChange);
        _todoList.on('dblclick', 'label', onLabelDoubleClick);
        _todoList.on('keyup', '.edit', onEditKeyUp);
        _todoList.on('focusout', '.edit', onEditBlur);
        _todoList.on('click', '.destroy', onDestroyClick);
    }

    function indexFromEl(el:Element) {
        var id = new JQuery(el).closest('li').data('id');
        var i = todos.length;

        while (i-- != 0) {
            if (todos[i].id == id) {
                return i;
            }
        }
        return -1;
    }

    function onNewTodoKeyUp(evt:jQuery.Event) {
        var _input = new JQuery(evt.target);
        var val = _input.val().trim();

        if (evt.which != ENTER_KEY || val == "") {
            return;
        }

        var todo = new Todo(val);

        if(store.add(todo)) {
            todos.push(todo);
        }

        _input.val('');
        render();
    }

    function onToggleAllChange(evt:jQuery.Event) {
        var isChecked = new JQuery(evt.target).is(":checked");

        store.overwrite(todos.map(function (todo:Todo):Todo {
            todo.completed = isChecked;
            return todo;
        }));

        render();
    }

    function onClearClick(evt:jQuery.Event) {
        if (store.overwrite(getActiveTodos())) {
            todos = store.findAll();
        }
        filter = 'all';
        render();
    }

    function onToggleChange(evt:jQuery.Event) {
        var i = indexFromEl(cast evt.target);
        todos[i].completed = new JQuery(evt.target).is(":checked");
        store.update(todos[i]);
        render();
    }

    function onLabelDoubleClick(evt:jQuery.Event) {
        var _input = new JQuery(evt.target).closest('li').addClass('editing').find('.edit');
        _input.val(cast _input.val()).focus();
    }

    function onEditKeyUp(evt:jQuery.Event) {
        if (evt.which == ENTER_KEY) {
            new JQuery(evt.target).blur();
        }

        if (evt.which == ESCAPE_KEY) {
            new JQuery(evt.target).data('abort', true).blur();
        }
    }

    function onEditBlur(evt:jQuery.Event) {
        var el:Element = cast evt.target;
        var _el = new JQuery(el);
        var val = _el.val().trim();

        if (_el.data('abort')) {
            _el.data('abort', false);
            render();
            return;
        }

        var i = indexFromEl(el);

        if (val != '') {
            todos[i].title = val;
        } else {
            todos.splice(i, 1);
        }

        store.update(todos[i]);

        render();
    }

    function onDestroyClick(evt:jQuery.Event) {
        var el:Element = cast evt.target;
        var i = indexFromEl(el);
        if (store.remove(todos[i].id)) {
            todos.splice(i, 1);
        }
        render();
    }

    function getFilteredTodos() {
        return todos.filter(function(todo) {
            return switch (filter) {
                case 'all': true;
                case 'completed': todo.completed;
                case 'active': !todo.completed;
                default: true;
            }
        });
    }

    function getActiveTodos() {
        return todos.filter(function(todo) {
            return !todo.completed;
        });
    }

    function renderFooter() {
        var todoCount = todos.length;
        var activeTodoCount = getActiveTodos().length;

        if (todoCount > 0) {
            var template = footerTemplate.execute({
                activeTodoCount: activeTodoCount,
                activeTodoWord: if (activeTodoCount != 1) 'items' else 'item',
                completedTodos: todoCount - activeTodoCount,
                filter: filter
            });
            _footer.html(template);
            _footer.show();
        } else {
            _footer.hide();
        }
    }

    public function render() {
        var filteredTodos = getFilteredTodos();

        function formatTodo(todo) {
            return {
                checked: if (todo.completed) 'checked' else '',
                completed: if (todo.completed) 'completed' else '',
                id: todo.id,
                title: todo.title
            }
        }

        _todoList.html([for (todo in filteredTodos) todoTemplate.execute(formatTodo(todo))].join(''));

        var activeTodos = todos.length > 0;

        if (activeTodos) {
            _main.show();
        } else {
            _main.hide();
        }

        _toggleAll.prop('checked', activeTodos);
        renderFooter();

        _newTodo.focus();
    }

    /**
        App.main is the entry-point of our application that we specify in build.hxml.  App.main is a
        static function and so it does not need a Todo instance to be executed.
    **/
    public static function main() {
        var todo = new App('todomvc-haxe');
        todo.render();

        // Normally in Haxe, we interact with external Javascript libraries with an extern class.
        // However, small interactions can use the magic "untyped __js__()" function.
        untyped __js__("Router({'/:filter': function (filter) { todo.filter = filter; todo.render(); } }).init('/all')");
    }
}
