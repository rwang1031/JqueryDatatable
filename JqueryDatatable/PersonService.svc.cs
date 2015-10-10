using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using JqueryDatatable.Models;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace JqueryDatatable
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "PersonService" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select PersonService.svc or PersonService.svc.cs at the Solution Explorer and start debugging.
    public class PersonService : IPersonService
    {
        
        public List<Person> GetPersons()
        {

           string _connectionString  = ConfigurationManager.ConnectionStrings["MyConnection"].ToString();
           DataSet _ds = new DataSet();

           List<Person> persons = new List<Person>();

           using (SqlConnection conn = new SqlConnection(_connectionString))
           {
               using (SqlCommand cmd = new SqlCommand("[core].[getPersons]"))
               {
                   cmd.Connection = conn;
                   cmd.CommandType = CommandType.StoredProcedure;
                   SqlDataAdapter adapter = new SqlDataAdapter();
                   adapter.SelectCommand = cmd;
                   adapter.Fill(_ds);

                   foreach (DataRow row in _ds.Tables[0].Rows)
                   {
                       Person person = new Person();
                       person.PersonID = int.Parse(row["BusinessEntityID"].ToString());
                       person.FirstName = row["FirstName"].ToString();
                       person.LastName = row["LastName"].ToString();
                       person.Title = row["Title"].ToString();
                       persons.Add(person);
                   }
               }
           }
           return persons;           
        }



    }
}
