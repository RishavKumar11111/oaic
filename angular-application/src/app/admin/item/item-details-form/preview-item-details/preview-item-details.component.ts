import { Component, Input, OnInit } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';


@Component({
  selector: 'app-preview-item-details',
  templateUrl: './preview-item-details.component.html',
  styleUrls: ['./preview-item-details.component.css']
})
export class PreviewItemDetailsComponent implements OnInit {

  @Input() ItemDetailsForm: any;

  Division: string = '';
  constructor(private service: CommonService) { }

  ngOnInit(): void {
      this.DivisionID.valueChanges.subscribe((x: any) => {
          if(this.DivisionID.value) {
            this.loadDivision();
          }
      })
  }


  loadDivision = async () => {
      try{
          const response = await this.service.get('/admin/getDivisionList');
          this.Division = response[response.findIndex((e: any) => e.DivisionID == this.DivisionID.value)].DivisionName;
      } catch(e) {
          console.error(e);
      }
  }



  get Implement() {
    return this.ItemDetailsForm.get('Implement')
  }
  get Make() {
    return this.ItemDetailsForm.get('Make')
  }
  get Model() {
    return this.ItemDetailsForm.get('Model')
  }
  get DivisionID() {
    return this.ItemDetailsForm.get('DivisionID')
  }
  get HSN() {
    return this.ItemDetailsForm.get('HSN')
  }
  get UnitOfMeasurement() {
    return this.ItemDetailsForm.get('UnitOfMeasurement')
  }
  get Taxability() {
    return this.ItemDetailsForm.get('Taxability')
  }
  get TaxRate() {
    return this.ItemDetailsForm.get('TaxRate')
  }
  get PurchaseInvoiceValue() {
    return this.ItemDetailsForm.get('PurchaseInvoiceValue')
  }
  get PurchaseTaxableValue() {
    return this.ItemDetailsForm.get('PurchaseTaxableValue')
  }
  get PurchaseCGST() {
    return this.ItemDetailsForm.get('PurchaseCGST')
  }
  get PurchaseSGST() {
    return this.ItemDetailsForm.get('PurchaseSGST')
  }
  get PurchaseIGST() {
    return this.ItemDetailsForm.get('PurchaseIGST')
  }
  get PurchaseSGSTOnePercent() {
    return this.ItemDetailsForm.get('PurchaseSGSTOnePercent')
  }
  get PurchaseCGSTOnePercent() {
    return this.ItemDetailsForm.get('PurchaseCGSTOnePercent')
  }
  get SellInvoiceValue() {
    return this.ItemDetailsForm.get('SellInvoiceValue')
  }
  get SellTaxableValue() {
    return this.ItemDetailsForm.get('SellTaxableValue')
  }
  get SellCGST() {
    return this.ItemDetailsForm.get('SellCGST')
  }
  get SellSGST() {
    return this.ItemDetailsForm.get('SellSGST')
  }
  get SellIGST() {
    return this.ItemDetailsForm.get('SellIGST')
  }
  get packagesList() {
    return this.ItemDetailsForm.get('packagesList')
  }

}