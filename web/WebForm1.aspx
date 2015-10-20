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
            var _specal = ["$", "(", ")", "\\"];
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
                    var callBackPara = /(?:var|)[\s]*([\w\W]*?)[=]?[\s]*_\$Async/.exec(thisItem)[1];
                    functionString = functionString.replace(funcFullInfo, "");
                    var item = {
                        callback: $.trim(callBackPara),
                        expression: $.trim(funcParamer)
                    };
                    container.push(item);
                }
                return _BuildFunction(container);
            }
            function _BuildFunction(options) {
                var thisNode = "";
                var result = "";
                for (var i = options.length - 1; i >= 0; i--) {
                    var item = options[i];
                    thisNode = "_$Async" + item.expression;
                    result = thisNode.match(/([\w\W]+)\);/)[1] + ",\r\n" + "function(){" + result + "}";
                    if (item.callback != _stringEmpty)
                        result = result + "," + item.callback + ",\"" + item.callback + "\"";
                    result += ")";
                }
                return "(function(){ " + result + " })();" + _$Async.toString() + "";
            }
            function _$Async(option, callback, inputdata, name) {
                if (typeof option == "function") {
                    var _$result = option() || "";
                    eval(name + "=\"" + _$result + "\"");
                    callback();
                }
                else {
                    var temp = option.success;
                    var success = function (data) {
                        var val;
                        if (temp != null) {
                            val = temp(data);
                        }
                        val = val || _stringEmpty;
                        if (typeof val == "String")
                            val = "\"" + val + "\"";
                        eval(name + "=val");
                        callback();
                    };
                    option.success = success;
                    $.ajax(option);
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
            var option = null;
            var r = async.Build(function () {
                option = _$Async(
                {
                    url: url + "&val=ajax1",
                    success: function (a) {
                        alert("success");
                        return a;
                    }
                });
                option = _$Async(
                {
                    url: url + "&val=ajax2",
                    success: function (a) {
                        alert(option);
                        return a;
                    }
                });
                _$Async(function () {
                    alert(result);
                });
            });
            eval(r);
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <input type="button" onclick="Show()" value="aaa" />
        </div>
    </form>
</body>
</html>
