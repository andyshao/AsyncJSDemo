using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace web
{

    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string val = Request.QueryString["val"];
            if (!string.IsNullOrEmpty(val))
            {
                Thread.Sleep(2000);
                Response.Write(val + "返回结果");
                Response.End();
            }
        }
    }
}