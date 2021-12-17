import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-calculate-item-price',
  templateUrl: './calculate-item-price.component.html',
  styleUrls: ['./calculate-item-price.component.css']
})
export class CalculateItemPriceComponent implements OnInit {

  @Input() ItemDetailsForm: any;

  constructor() { }


  ngOnInit(): void {
    

    this.TaxRate.valueChanges.subscribe((x: any) => {
      this.calculatePTax();
      this.calculateSTax();
    })
    this.Taxability.valueChanges.subscribe((x: any) => {
      const taxRate = this.Taxability.value == 'Taxable' ? 12 : 0;
      this.TaxRate.setValue(taxRate);
      this.calculatePTax();
      this.calculateSTax();
    })

  }

  calculatePTax = () => {    
      const taxRate = this.TaxRate.value;
      let pInvoiceValue = this.PurchaseInvoiceValue.value;
      
      if(taxRate != undefined) {
          if (pInvoiceValue) {            
              let invoiceValue = parseFloat(pInvoiceValue);
              const gstRate = +taxRate;
              const onePercent = invoiceValue / (100 + gstRate);

              const p_taxable_value = (onePercent * 100).toFixed(2);
              
              this.PurchaseTaxableValue.setValue(p_taxable_value);

              const gst = ( onePercent * (gstRate / 2)).toFixed(2);
              
              this.PurchaseSGST.setValue(gst);
              this.PurchaseCGST.setValue(gst);
              this.PurchaseIGST.setValue(0.00);
              
          } else {
            this.PurchaseSGST.setValue(0.00);
            this.PurchaseCGST.setValue(0.00);
            this.PurchaseIGST.setValue(0.00);
          }
      } else {
          // window.alert('Please select Tax rate first')
      }
  }
  calculateSTax = () => {
      const taxRate = this.TaxRate.value;
      let sInvoiceValue = this.SellInvoiceValue.value;      
      if(taxRate != undefined) {
          if (sInvoiceValue) {
              let invoiceValue = parseFloat(sInvoiceValue);
              const gstRate = +taxRate;
              const onePercent = invoiceValue / (100 + gstRate);
              const taxable_value = (onePercent * 100).toFixed(2);
              
              this.SellTaxableValue.setValue(taxable_value);

              const gst = ( onePercent * (gstRate / 2)).toFixed(2);

              this.SellSGST.setValue(gst);
              this.SellCGST.setValue(gst);
              this.SellIGST.setValue(0.00);
          } else {
            this.SellSGST.setValue(0.00);
            this.SellCGST.setValue(0.00);
            this.SellIGST.setValue(0.00);
          }
      } else {
          // window.alert('Please select Tax rate first')
      }
  }

  filterValue = function($event: any) {
      if (isNaN((String as any).fromCharCode($event.keyCode))) {
          $event.preventDefault();
      }
  };





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
}
