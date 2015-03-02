package todomvc;

import js.Browser.window;
import js.html.Storage;
import haxe.Json;


/**
    Classes must implement the Storable interface to be used in the Store.
**/
interface Storable {
    public var id:Int;
}


/**
    Store is a generic class that will interface with localStorage
**/
class Store<T:Storable> {
    var prefix:String;
    var storage:Storage = window.localStorage;

    public function new(prefix:String) {
        this.prefix = prefix;

        if (findAll() == null) {
            overwrite([]);
        }
    }

    public function add(record:T):Bool {
        var records:Array<T> = findAll();
        records.push(record);
        return overwrite(records);
    }

    public function findAll():Array<T> {
        return Json.parse(storage.getItem(prefix));
    }

    public function remove(id:Int):Bool {
        var records:Array<T> = findAll();
        var recordLen = records.length;
        records = records.filter(function(record) { return record.id != id; } );
        if (records.length != recordLen) {
            return overwrite(records);
        } else {
            return false;
        }
    }

    public function update(newRecord:T) {
        overwrite(findAll().map(function(record) {
            return if (record.id == newRecord.id) newRecord else record;
        }));
    }

    public function overwrite(records:Array<T>):Bool {
        try {
            storage.setItem(prefix, Json.stringify(records));
        } catch (e:js.html.EventException) {
            return false;
        }
        return true;
    }
}
