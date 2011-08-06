/*
 * get the file handler
 */
var fs = require('fs');

/*
 * define the possible values:
 * section: [section]
 * param: key=value
 * comment: ;this is a comment
 * comment: #this is a comment
 */
var regex = {
	section: /^\s*\[\s*([^\]]*)\s*\]\s*$/,
	param: /^\s*([\w\.\-\_]+)\s*=\s*(.*)\s*$/,
	comment: /\s*;.*$/
};

/*
 * parses a .ini file
 * @param: {String} file, the location of the .ini file
 * @param: {Function} callback, the function that will be called when parsing is done
 * @return: none
 */
module.exports.parse = function(file, s, callback){
	if(!callback){
		return;
	}
	s = Boolean(s);
	fs.readFile(file, 'utf8', function(err, data){
		if(err){
			callback(err);
		}else{
			callback(null, parse(data,s));
		}
	});
};

module.exports.parseSync = function(file,s){
	s = Boolean(s);
	return parse(fs.readFileSync(file, 'utf8'),s);
};

function parse(data,s){
	s = Boolean(s);
	var value = {};
	var lines = data.split(/\r\n|\r|\n/);
	var section = null;
	lines.forEach(function(line){
		line = line.replace(regex.comment,"");
		if(regex.param.test(line)){
			var match = line.match(regex.param);
			if(section){
				value[section[0]][section[1]][match[1]] = match[2];
			}else{
				value[match[1]] = match[2];
			}
		}else if(s && regex.section.test(line)){
			var match = line.match(regex.section);
			value[match[1]] = value[match[1]] ||  [];
			value[match[1]][value[match[1]].length] = [];
			section = [match[1],value[match[1]].length -1];
		}else if(line.length == 0 && section){
			section = null;
		};
	});
	return value;
}

module.exports.parseString = parse;
