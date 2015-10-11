using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JqueryDatatable.Models
{
    public class ReturnModel
    {
        public int draw {get;set;}
        public int recordsTotal{get;set;}
        public int recordsFiltered{get;set;}
        public List<Person> data {get;set;}
    }
}