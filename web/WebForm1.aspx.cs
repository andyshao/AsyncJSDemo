using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace web
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string action = Request.QueryString["action"];
            string val = Request.QueryString["val"];
            if (action == "ajax")
            {
                Thread.Sleep(2000);
                Response.Write(val);
                Response.End();
            }
        }
    }
}