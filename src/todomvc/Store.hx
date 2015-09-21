package todomvc;

import js.Browser.window;
import js.html.Storage;
import haxe.Json;


#if (haxe_ver >= 3.2)
    typedef EventException = js.html.Exception;
#else
    typedef EventException = js.html.EventException;
#end

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
    var storage:Storage;

    public function new(prefix:String, ?storage:Storage) {
        this.prefix = prefix;
        this.storage = if (storage == null) window.localStorage else storage;

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

    public function update(newRecord:T):Bool {
        return overwrite(findAll().map(function(record) {
            return if (record.id == newRecord.id) newRecord else record;
        }));
    }

    public function overwrite(records:Array<T>):Bool {
        try {
            storage.setItem(prefix, Json.stringify(records));
        } catch (e:EventException) {
            return false;
        }
        return true;
    }
}
