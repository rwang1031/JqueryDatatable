﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using JqueryDatatable.Models;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Script.Serialization;

namespace JqueryDatatable
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "PersonService" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select PersonService.svc or PersonService.svc.cs at the Solution Explorer and start debugging.
    public class PersonService : IPersonService
    {
        
        public ReturnModel GetPersons()
        {

            var draw =int.Parse(HttpContext.Current.Request.Params["draw"]);
            var start = int.Parse(HttpContext.Current.Request.Params["start"]);
            var length = int.Parse(HttpContext.Current.Request.Params["length"]);
            var searchKey = (string)HttpContext.Current.Request.Params["search[value]"];


           string _connectionString  = ConfigurationManager.ConnectionStrings["MyConnection"].ToString();
           DataSet _ds = new DataSet();

           List<Person> persons = new List<Person>();
           ReturnModel dataToReturn = new ReturnModel();

           using (SqlConnection conn = new SqlConnection(_connectionString))
           {
               using (SqlCommand cmd = new SqlCommand("[core].[getPersons]"))
               {
                   cmd.Connection = conn;
                   cmd.CommandType = CommandType.StoredProcedure;
                   cmd.Parameters.Add("@start", SqlDbType.Int).Value = start;
                   cmd.Parameters.Add("@length", SqlDbType.Int).Value = length;
                   cmd.Parameters.Add("@searchKey", SqlDbType.VarChar).Value = searchKey;
                   SqlParameter para = cmd.Parameters.Add("@recordsTotal", SqlDbType.Int);
                   para.Direction = ParameterDirection.Output;  
                   SqlParameter para1 = cmd.Parameters.Add("recordsFiltered", SqlDbType.Int);
                   para1.Direction = ParameterDirection.Output;  
 
                   SqlDataAdapter adapter = new SqlDataAdapter();
                   adapter.SelectCommand = cmd;
                   adapter.Fill(_ds);

                   int recordsTotal =int.Parse(para.Value.ToString());
                   int recordsFiltered = int.Parse(para1.Value.ToString());

                   foreach (DataRow row in _ds.Tables[0].Rows)
                   {
                       Person person = new Person();
                       person.PersonID = int.Parse(row["BusinessEntityID"].ToString());
                       person.FirstName = row["FirstName"].ToString();
                       person.LastName = row["LastName"].ToString();
                       person.Title = row["Title"].ToString();
                       persons.Add(person);

                   }

                   dataToReturn.recordsTotal = recordsTotal;
                   dataToReturn.recordsFiltered = recordsFiltered;
                   dataToReturn.draw = draw;
                   dataToReturn.data = persons;
               }
           }
           return dataToReturn;           
        }


        
        public ReturnModelLegacy GetFundsLegacy()
        {

            var sEcho = int.Parse(HttpContext.Current.Request.Params["sEcho"]);
            var iDisplayStart = int.Parse(HttpContext.Current.Request.Params["iDisplayStart"]);
            var iDisplayLength = int.Parse(HttpContext.Current.Request.Params["iDisplayLength"]);
            var sSearch = (string)HttpContext.Current.Request.Params["sSearch"];


            string _connectionString = ConfigurationManager.ConnectionStrings["MyConnection"].ToString();
            DataSet _ds = new DataSet();

            List<Fund> funds = new List<Fund>();
            ReturnModelLegacy dataToReturn = new ReturnModelLegacy();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("[core].[getFunds]"))
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@start", SqlDbType.Int).Value = iDisplayStart;
                    cmd.Parameters.Add("@length", SqlDbType.Int).Value = iDisplayLength;
                    cmd.Parameters.Add("@searchKey", SqlDbType.VarChar).Value = sSearch;
                    SqlParameter para = cmd.Parameters.Add("@recordsTotal", SqlDbType.Int);
                    para.Direction = ParameterDirection.Output;
                    SqlParameter para1 = cmd.Parameters.Add("@recordsFiltered", SqlDbType.Int);
                    para1.Direction = ParameterDirection.Output;

                    SqlDataAdapter adapter = new SqlDataAdapter();
                    adapter.SelectCommand = cmd;
                    adapter.Fill(_ds);

                    int iTotalRecords = int.Parse(para.Value.ToString());
                    int iTotalDisplayRecords = int.Parse(para1.Value.ToString());

                    foreach (DataRow row in _ds.Tables[0].Rows)
                    {
                        Fund fund = new Fund();
                        fund.InstrumentID = int.Parse(row["fldInstrumentID"].ToString());
                        fund.FundName = row["fldFundName"].ToString();
                        fund.FundServCode = row["fldFundServCode"].ToString();
                        fund.FundType = row["fldFundType"].ToString();
                        funds.Add(fund);
                    }

                    JavaScriptSerializer jss = new JavaScriptSerializer();
                    List<List<string>> results = new List<List<string>>();
                    List<string> result;

                    foreach (Fund fund in funds)
                    {
                        result = new List<string>();
                        result.Add(fund.InstrumentID.ToString());
                        result.Add(fund.FundServCode);
                        result.Add(fund.FundName);
                        result.Add(fund.FundType);
                        results.Add(result);
                    }
           
                    dataToReturn.iTotalRecords = iTotalRecords;
                    dataToReturn.iTotalDisplayRecords = iTotalDisplayRecords;
                    dataToReturn.sEcho = sEcho;
                    dataToReturn.aaData = results;
                }
            }

            System.Threading.Thread.Sleep(5000);
            return dataToReturn;
        }



    }
}
