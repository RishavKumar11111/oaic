import { ToastrService } from 'ngx-toastr';
import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';
import { FormArray, FormBuilder, FormControl } from '@angular/forms';

@Component({
  selector: 'app-non-subsidies-orders',
  templateUrl: './non-subsidies-orders.component.html',
  styleUrls: ['./non-subsidies-orders.component.css']
})
export class NonSubsidiesOrdersComponent implements OnInit {

  nonSubsidyData: any = {};
  modelDetails: any = {};
  orderList: FormArray = new FormArray([]);
  @Output() showPODetais = new EventEmitter<any>();
  customerDetails: FormControl = new FormControl('');
  vendorID: FormControl = new FormControl('');
  constructor(private toastr: ToastrService) { 
  }

  ngOnInit(): void {
  }





  shwPurchaseOrderForNonSubsidy = async () => {
    if(this.orderList.value.length > 0) {
          this.showPODetais.emit({ orderList: this.orderList.value, customerDetails: this.customerDetails.value, vendorID: this.vendorID.value });
    } else {
      this.toastr.error('Please add munimum 1 Item/Model to Initiate P.O.')
    }
      
  }
  calculateItemWiseTax = () => {
      const quantity = this.nonSubsidyData.Quantity ? this.nonSubsidyData.Quantity : 1;
      this.modelDetails.TotalPurchaseTaxableValue = this.modelDetails.PurchaseTaxableValue * quantity;
      this.modelDetails.TotalPurchaseCGST = this.modelDetails.PurchaseCGST * quantity;
      this.modelDetails.TotalPurchaseSGST = this.modelDetails.PurchaseCGST * quantity;
      this.modelDetails.TotalPurchaseInvoiceValue = this.modelDetails.PurchaseInvoiceValue * quantity;
  }

}
