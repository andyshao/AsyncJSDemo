<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="web.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="jquery-1.8.2.min.js"></script>
    <script>
        AsyncJs = function () {
            var _stringEmpty = "";
            var _specal = ["^", "$", ".", "*", "+", "-", "?", "=", "!", ":", "|", "\\", "/", "(", ")", "[", "]", "{", "}"];
            var _debug = true;
            this.Build = function (func) {
                var functionString = func.toString();
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
        }

        function Show() {
            var async = new AsyncJs();
            var url = "WebForm1.aspx?action=ajax";
            var str = async.Build(function () {
                var result1 = _$Async(
                {
                    url: url,
                    data: { "val": "ajax1" },
                    success: function (data) {
                        alert("success:" + data);
                        return data;
                    }
                });
                var result2 = _$Async(
                {
                    url: url,
                    data: { "val": "ajax2" },
                    success: function (data) {
                        alert("success:" + data);
                        return { data: data };
                    }
                });
                _$Async(function () {
                    alert("2 ajax retun values=" + result1 + "|" + result2.data);
                });
                _$Async(
                {
                    url: url,
                    data: { "val": result1 + result2.data },
                    success: function (data) {
                        alert(data);
                    }
                });
            });
            eval(str);
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <input type="button" onclick="Show()" value="aaa" />
            <input type="text" />
        </div>
    </form>
</body>
</html>
