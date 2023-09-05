//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Joel Storr on 23.08.23.
//

import Foundation


extension Date {
    /*
         //Old way
         func convertToMonthYearFormat()-> String{
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "MMM yyyy"
             return dateFormatter.string(from: self)
        }
     */
    
    func convertToMonthYearFormat()-> String{
        return formatted(.dateTime.month().year())
    }
}
