(function ($hx_exports) { "use strict";
$hx_exports.todomvc = $hx_exports.todomvc || {};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = true;
js.Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else return o.__class__;
};
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
};
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js.Boot.__interfLoop(js.Boot.getClass(o),cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
var todomvc = {};
todomvc.Storable = function() { };
todomvc.Storable.__name__ = true;
todomvc.Storable.prototype = {
	__class__: todomvc.Storable
};
todomvc.Store = $hx_exports.todomvc.Store = function(prefix,storage) {
	this.prefix = prefix;
	if(storage == null) this.storage = window.localStorage; else this.storage = storage;
	if(this.findAll() == null) this.overwrite([]);
};
todomvc.Store.__name__ = true;
todomvc.Store.prototype = {
	add: function(record) {
		var records = this.findAll();
		records.push(record);
		return this.overwrite(records);
	}
	,findAll: function() {
		return JSON.parse(this.storage.getItem(this.prefix));
	}
	,remove: function(id) {
		var records = this.findAll();
		var recordLen = records.length;
		records = records.filter(function(record) {
			return record.id != id;
		});
		if(records.length != recordLen) return this.overwrite(records); else return false;
	}
	,update: function(newRecord) {
		return this.overwrite(this.findAll().map(function(record) {
			if(record.id == newRecord.id) return newRecord; else return record;
		}));
	}
	,overwrite: function(records) {
		try {
			this.storage.setItem(this.prefix,JSON.stringify(records));
		} catch( e ) {
			if( js.Boot.__instanceof(e,EventException) ) {
				return false;
			} else throw(e);
		}
		return true;
	}
	,__class__: todomvc.Store
};
todomvc.Todo = $hx_exports.todomvc.Todo = function(title,completed,id) {
	if(completed == null) completed = false;
	this.title = title;
	this.completed = completed;
	if(id == null) this.id = new Date().getTime(); else this.id = id;
};
todomvc.Todo.__name__ = true;
todomvc.Todo.__interfaces__ = [todomvc.Storable];
todomvc.Todo.prototype = {
	__class__: todomvc.Todo
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=common.js.map