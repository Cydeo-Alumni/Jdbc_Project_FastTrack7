package com.cydeo.jdbctests.day01;

import java.sql.*;

public class P01_TestSQLLite {

    public static void main(String[] args) throws SQLException {
        //CONNECTION STRING
        String dbUrl = System.getenv("DB_URL");
        // This is your own path
        String dbUsername ="";
        String dbPassword = "";

        /*
        // Comes from Project env variable
        System.out.println(System.getenv("Mypassword"));
        // Comes from Local env variable
        System.out.println(System.getenv("LIBRARY_USER"));
        // LIBRARY_USER=librarian@library.com
        */



        //Create the connection
        //DriverManager class getConnection Method will help to connect database
        Connection conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

        //It will help us to execute queries
        Statement statement = conn.createStatement();

        //ResultSet will store data after execution. It stores only data(there is no table info)
        ResultSet rs = statement.executeQuery("select * from Categories");


        while (rs.next()){

            System.out.println(rs.getString(1)+" - "+rs.getString(2)+" - "+rs.getString(3));

        }

        //close connection
        rs.close();
        statement.close();
        conn.close();

    }}