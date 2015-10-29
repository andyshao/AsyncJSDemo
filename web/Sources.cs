using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace web
{
    public class Sources
    {


        public class Bank
        {
            public int ID { get; set; }
            public string Name { get; set; }

        }
        public class ChildBank
        {
            public int ID { get; set; }
            public string Name { get; set; }
            public int BankID { get; set; }
        }
        public class People
        {
            public int ID { get; set; }
            public string Name { get; set; }

            public string Phone { get; set; }
            public int ChildBankID { get; set; }
        }

        public static List<Bank> listBanks = new List<Bank>()
        {
            new Bank(){ID=1,Name="中国银行"},
            new Bank(){ID=2,Name="农业银行"},
            new Bank(){ID=3,Name="工商银行"},
            new Bank(){ID=4,Name="建设银行"}
        };

        public static List<ChildBank> listChildBanks = new List<ChildBank>()
        {
            new ChildBank(){ID=1,Name="中国银行A支行",BankID=1},
            new ChildBank(){ID=2,Name="中国银行B支行",BankID=1},
            new ChildBank(){ID=3,Name="中国银行C支行",BankID=1},
            new ChildBank(){ID=4,Name="中国银行D支行",BankID=1},
            new ChildBank(){ID=5,Name="中国银行E支行",BankID=1},
            new ChildBank(){ID=6,Name="农业银行A支行",BankID=2},
            new ChildBank(){ID=7,Name="农业银行B支行",BankID=2},
            new ChildBank(){ID=8,Name="工商银行A支行",BankID=3},
            new ChildBank(){ID=9,Name="建设银行A支行",BankID=4},  
        };

        public static List<People> listPeoples = new List<People>()
        {
            new People(){Name="A",ChildBankID=1,Phone="10086"},
            new People(){Name="A1",ChildBankID=1,Phone="13600000"},
            new People(){Name="A2",ChildBankID=2},
            new People(){Name="A3",ChildBankID=3},
            new People(){Name="A4",ChildBankID=4},
            new People(){Name="A5",ChildBankID=5},
            new People(){Name="A6",ChildBankID=6},
            new People(){Name="A7",ChildBankID=1},
            new People(){Name="A8",ChildBankID=7},
            new People(){Name="A11",ChildBankID=8},
            new People(){Name="A12",ChildBankID=9},
            new People(){Name="A13",ChildBankID=9},
            new People(){Name="A14",ChildBankID=9},
            new People(){Name="A15",ChildBankID=9},
        };
    }
}