package com.cydeo.jdbctests.day01;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class P02_Categories {
    public static void main(String[] args) throws SQLException {
        //CONNECTION STRING
        String dbUrl = "jdbc:sqlite:/Users/ema/Desktop/northwind.db";
        String dbUsername ="";
        String dbPassword = "";

        //Create the connection
        //DriverManager class getConnection Method will help to connect database
        Connection conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

        //It will help us to execute queries
        Statement statement = conn.createStatement();

        //ResultSet will store data after execution. It stores only data(there is no table info)
        ResultSet rs = statement.executeQuery("select * from Categories");

        List<Categories> allCategories = new ArrayList<>();
        while (rs.next()){

            String categoryName = rs.getString(2);
            String desc = rs.getString(3);

            Categories category=new Categories();
            category.setCategoryName(categoryName);
            category.setDesc(desc);

            allCategories.add(category);

        }
        for (Categories eachCategory : allCategories) {
            System.out.println("eachCategory = " + eachCategory);
        }

        //close connection
        rs.close();
        statement.close();
        conn.close();

    }}

