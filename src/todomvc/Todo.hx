package todomvc;

import Date;

/**
    The Todo Class represents each todo list item.
**/
#if sharedcode
    @:expose
#else
    extern
#end
class Todo implements todomvc.Store.Storable {
    public var id:Int;
    public var title:String;
    public var completed:Bool;

    public function new(title:String, completed:Bool=false, ?id:Int) {
        this.title = title;
        this.completed= completed;

        // Here, we're using the current epoch time as a unique id.  Not good for a production
        // environment but it serves our purposes here.
        this.id = if (id == null) cast Date.now().getTime() else id;
    }
}
