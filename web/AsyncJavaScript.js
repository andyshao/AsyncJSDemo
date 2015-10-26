AsyncJs = function () {
    var _stringEmpty = "";
    var _specal = ["^", "$", ".", "*", "+", "-", "?", "=", "!", ":", "|", "\\", "/", "(", ")", "[", "]", "{", "}"];
    var _debug = true;
    this.Build = function (func) {
        var functionString = func.toString();
        functionString = _RemoveNoteString(functionString);
        var regex = /(?:var[\s]*[\S]+[\s]*[=][\s]*?|[\S]+[\s]*[=][\s]*?|)_\$Async/g;
        var groups = functionString.match(regex);
        var container = [];
        for (var i = 0; i < groups.length; i++) {
            var thisItem = groups[i];
            var nextItem = i + 1 == groups.length ? null : groups[i + 1];
            var dynamicRegex;
            if (nextItem != null)
                dynamicRegex = eval("/(" + _SpecalFontChange(thisItem) + "([\\w\\W]+?))" + _SpecalFontChange(nextItem) + "/");
            else
                dynamicRegex = eval("/(" + _SpecalFontChange(thisItem) + "([\\w\\W]+))}/");
            var funcPara = dynamicRegex.exec(functionString);
            var funcFullInfo = funcPara[1];
            var funcParamer = funcPara[2];
            regex = /(?:var|)[\s]*([\w\W]*?)[=]?[\s]*_\$Async/;
            var paraName = regex.exec(thisItem)[1];
            var isDefinePara = /var[\s]+[\S]+[\s]*[=][\s]*_\$Async/.test(thisItem);
            functionString = functionString.replace(funcFullInfo, "");
            var item = {
                paraName: $.trim(paraName),
                expression: $.trim(funcParamer),
                isDefinePara: isDefinePara
            };
            container.push(item);
        }
        var result = _BuildFunction(container);
        if (_debug)
            console.log(result);
        return result;
    }
    function _BuildFunction(options) {
        var thisNode = "";
        var result = "";
        var defineParaArray = [];
        for (var i = options.length - 1; i >= 0; i--) {
            var item = options[i];
            thisNode = "_$Async" + item.expression;
            result = thisNode.match(/([\w\W]+)\);/)[1] + "," + "function(){" + result + "}";
            if (item.paraName != _stringEmpty)
                result = result + ",\"" + item.paraName + "\"";
            result += ")";
            if (item.isDefinePara)
                defineParaArray.push(item.paraName);
        }
        var defineInfos = "";
        for (var i = 0; i < defineParaArray.length; i++) {
            defineInfos += "var " + defineParaArray[i] + ";\r\n";
        }
        return "(function(){\r\n" + defineInfos + "(function(){ " + result + " })();\r\n" + _$Async.toString() + "})()";
    }
    function _$Async(_$option, _$callback, _$name) {
        var _$val;
        if (typeof _$option == "function") {
            var _$val = _$option();
            eval(_$name + "=_$val");
            _$callback();
        }
        else {
            var _$tempFunction = _$option.success;
            var _$success = function (data) {
                if (_$tempFunction != null) {
                    _$val = _$tempFunction(data);
                }
                eval(_$name + "=_$val");
                _$callback();
            };
            _$option.success = _$success;
            $.ajax(_$option);
        }
    }
    function _SpecalFontChange(inputstr) {
        var result = "";
        for (var index in inputstr) {
            var item = inputstr[index];
            if (_specal.indexOf(item) >= 0) {
                result += "\\"
            }
            result += item;
        }
        return result;
    }
    //取出注释(remove note)
    function _RemoveNoteString(inputstr) {
        var matchArray = inputstr.match(/[\w\W]+?(?:\r|\n)/g);
        for (var i in matchArray) {
            var item = matchArray[i];
            if (/^\/\/[\w\W]*$/.test($.trim(item)))
                inputstr = inputstr.replace(item, "");
        }
        return inputstr;
    }
}