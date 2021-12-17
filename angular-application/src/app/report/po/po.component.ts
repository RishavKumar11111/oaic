import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-po',
  templateUrl: './po.component.html',
  styleUrls: ['./po.component.css']
})
export class PoComponent implements OnInit {

  @Input() PODetails: any = {};
  @Input() PONo: any;
  DMDetails: any = {};
  accountantDetails: any = {};
  vendorDetails: any = {};
  customerDetails: any = {};
  orderList: any = [];
  indent_no: any;
  indent_date: any;
  constructor() { }

  ngOnInit(): void {
    this.DMDetails = this.PODetails.DMDetails;
    this.accountantDetails = this.PODetails.accountantDetails;
    this.vendorDetails = this.PODetails.vendorDetails;
    this.customerDetails = this.PODetails.customerDetails;
    this.orderList = this.PODetails.orderList;
    this.indent_date = this.DMDetails.ApprovedDate ? this.DMDetails.ApprovedDate : new Date();
    this.indent_no = this.DMDetails.PONo ? this.DMDetails.PONo : this.PONo.value;
    this.PONo.valueChanges.subscribe((x: any) => {
      this.indent_no = x;
    })
  }

}
