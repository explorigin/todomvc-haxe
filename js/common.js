(function ($hx_exports) { "use strict";
$hx_exports.todomvc = $hx_exports.todomvc || {};
Math.__name__ = true;
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
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
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	if(typeof window != "undefined") return window[name]; else return global[name];
};
var todomvc_Storable = function() { };
todomvc_Storable.__name__ = true;
todomvc_Storable.prototype = {
	__class__: todomvc_Storable
};
var todomvc_Store = $hx_exports.todomvc.Store = function(prefix,storage) {
	this.prefix = prefix;
	if(storage == null) this.storage = window.localStorage; else this.storage = storage;
	if(this.findAll() == null) this.overwrite([]);
};
todomvc_Store.__name__ = true;
todomvc_Store.prototype = {
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
			if( js_Boot.__instanceof(e,Exception) ) {
				return false;
			} else throw(e);
		}
		return true;
	}
	,__class__: todomvc_Store
};
var todomvc_Todo = $hx_exports.todomvc.Todo = function(title,completed,id) {
	if(completed == null) completed = false;
	this.title = title;
	this.completed = completed;
	if(id == null) this.id = new Date().getTime(); else this.id = id;
};
todomvc_Todo.__name__ = true;
todomvc_Todo.__interfaces__ = [todomvc_Storable];
todomvc_Todo.prototype = {
	__class__: todomvc_Todo
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
js_Boot.__toStr = {}.toString;
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=common.js.map