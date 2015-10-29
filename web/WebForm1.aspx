<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="web.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="jquery-1.8.2.min.js"></script>
    <script src="AsyncJavaScript.js"></script>
    <script>
        function Show() {
            var js = new AsyncJs();
            var url = "WebForm1.aspx";
            var func = js.Build(function () {
                _$Async(function () {
                    alert("点击后开始第一次ajax请求");
                });
                _$Async({
                    url: url,
                    data: { val: "第一次ajax请求" },
                    success: function (data) {
                        alert("第一次请求结束，结果:" + data);
                    }
                });
                _$Async(function () {
                    alert("点击后开始第二次ajax请求");
                });
                var result = _$Async({
                    url: url,
                    data: { val: "第二次ajax请求" },
                    success: function (data) {
                        return data;
                    }
                });
                _$Async(function () {
                    alert("第二次请求结束，结果:" + result);
                });

            });
            eval(func);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <input type="button" onclick="Show()" value="查询" />
            <input type="text" />
        </div>
    </form>
</body>
</html>
