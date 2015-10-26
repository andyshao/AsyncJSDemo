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

                //var result2 = _$Async(
                //{
                //    url: url,
                //    data: { "val": "ajax2" },
                //    success: function (data) {
                //        alert("success:" + data);
                //        return { data: data };
                //    }
                //});
                //_$Async(function () {
                //    alert("2 ajax retun values=" + result1 + "|" + result2.data);
                //});
                //_$Async(
                //{
                //    url: url,
                //    data: { "val": result1 + result2.data },
                //    success: function (data) {
                //        alert(data);
                //    }
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
