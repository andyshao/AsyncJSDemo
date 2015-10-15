<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="web.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script>
        AsyncJs = function () {
            var _stringEmpty = "";
            var _specal = ["$", "(", ")", "\\"];
            this.Build = function (func) {
                var functionString = func.toString();
                var regex = /(?:var)?[ ]*([\S]*?)[ ]*?=?[ ]*?_\$Async\([\w\W]+?\);/g;
                var groups = functionString.match(regex);
                var result = "";
                var prev = "";
                var next = "";
                for (var i in groups) {
                    var item = groups[i];
                    var matchArray = regex.exec(item);
                    next = matchArray[0];
                    result += next;
                    if (prev != _stringEmpty) {
                        functionString = functionString.replace(prev, _stringEmpty);
                        var regexOther = eval("/(?:function[\\s]*\\(\\)[\\s]*{[ ]*([\\w\\W]+?)" + _SpecalFontChange(next.trim()) + ")/");
                        var j = regexOther.exec(functionString);
                    }
                    prev = next;


                    //if (matchArray.length == 2) {
                    //    next = matchArray[1];
                    //    if (next != _stringEmpty) {
                    //        if (prev != _stringEmpty) {
                    //            result = prev + next;
                    //        }
                    //        prev = next;
                    //    }
                    //}
                    regex.lastIndex = 0;
                }
                functionString = _$Async.toString() + "(" + functionString + ")()";
                return functionString;
            }
            function _$Async(option) {

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
            var a = "1";
            var r = async.Build(function () {
                var result = _$Async({ url: "\\()@#$" });
                var a = result.data;
                result = _$Async({ url: a });
                _$Async({ url: a });
            })
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
