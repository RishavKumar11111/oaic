import { Component, Input, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-mrr',
  templateUrl: './mrr.component.html',
  styleUrls: ['./mrr.component.css']
})
export class MrrComponent implements OnInit {

  @Input() AccountantDetails: any = {};
  @Input() DMDetails: any = {};
  @Input() printData: any = [];
  @Input() vendorDetails: any = {};
  @Input() invoice: any = {};
  @Input() mrr: any = {}
  received_date: any = '';
  totalPriceInTable: any = 0;
  finalAmount: number = 0
  constructor(private layoutService: LayoutService) {
    this.received_date = this.layoutService.getCurrentDate();
  }

  ngOnInit(): void {
    this.totalPriceInTable = this.printData.reduce((a: any, b: any) => a + +b.TotalPurchaseInvoiceValue, 0);
    this.finalAmount = this.totalPriceInTable - this.printData[0].Discount
  }

}
