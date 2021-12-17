import { ToastrService } from 'ngx-toastr';
import { Component, Input, OnInit, Output, EventEmitter } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-subsidies-orders',
  templateUrl: './subsidies-orders.component.html',
  styleUrls: ['./subsidies-orders.component.css']
})
export class SubsidiesOrdersComponent implements OnInit {

  search_farmer_name: string = '';
  search_permit_no: string = '';
  @Input() financialYear: any;
  @Output() showPODetais = new EventEmitter<any>();
  allData: any = [];
  finalPrice: any;
  constructor(private service: CommonService, private toastr: ToastrService) { }

  ngOnInit(): void {
    this.financialYear.valueChanges.subscribe((x: string) => {
      this.loadAllOrders(x);
    })
    if (this.financialYear.value) {
      this.loadAllOrders(this.financialYear.value);
    }
  }

  showSinglePO(x: any) {
    this.finalPrice = x.finalPrice;
    if (this.finalPrice == "0") {
      this.toastr.error('PO cannot be generated if the final price is 0');
    }
    else {
      x.VendorID = x.dealer.VendorID;
      x.TotalPurchaseTaxableValue = x.PurchaseTaxableValue;
      x.TotalPurchaseCGST = x.PurchaseCGST;
      x.TotalPurchaseSGST = x.PurchaseCGST;
      x.TotalPurchaseIGST = x.PurchaseIGST;
      x.TotalPurchaseInvoiceValue = x.PurchaseInvoiceValue;

      const taxRate = x.TaxRate || 12
      const totalTaxableValue = (x.FullCost / (100 + +taxRate)) * 100
      const totalCGST = (totalTaxableValue / 100) * (taxRate / 2)
      const totalSGST = (totalTaxableValue / 100) * (taxRate / 2)
      const totalInvoiceValue = x.FullCost || 0

      x.TotalSellTaxableValue = totalTaxableValue
      x.TotalSellCGST = totalCGST
      x.TotalSellSGST = totalSGST
      x.TotalSellIGST = 0
      x.TotalSellInvoiceValue = totalInvoiceValue

      x.OrderReferenceNo = x.permit_no;
      x.POAmount = x.TotalPurchaseInvoiceValue;
      const customerDetails = {
        permit_no: x.permit_no,
        farmer_name: x.farmer_name,
        farmer_father_name: x.farmer_father_name,
        village_name: x.village_name,
        gp_name: x.gp_name,
        block_name: x.block_name,
        dist_name: x.dist_name
      }
      this.showPODetais.emit({ orderList: [x], customerDetails: customerDetails, vendorID: x.VendorID });
    }
  }


  loadAllOrders = async (x: string) => {
    try {
      this.allData = await this.service.get(`/accountant/getAllOrdersForGI?finYear=${x}`);
      this.allData.forEach((element: any) => {
        element.finalPrice = element.PurchaseInvoiceValue || 0;
        element.dealer = '';
        element.Quantity = 1;
      });
    } catch (e) {
      console.error(e);
      this.toastr.error('Unable to Load All Subsidies Permit List');
    }
  }


}
