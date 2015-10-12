using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JqueryDatatable.Models
{
    public class ReturnModelLegacy
    {
        public int sEcho { get; set; }
        public int iTotalRecords { get; set; }
        public int iTotalDisplayRecords { get; set; }
        public List<List<string>> aaData { get; set; }
    }
}