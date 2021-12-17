import { CommonService } from '../../../../services/common.service';
import { ToastrService } from 'ngx-toastr';
import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-enter-packages',
  templateUrl: './enter-packages.component.html',
  styleUrls: ['./enter-packages.component.css']
})
export class EnterPackagesComponent implements OnInit {

  @Input() ItemDetailsForm: any;
  packagingForm: FormGroup;
  packageSizeList: any = [];
  constructor(private fb: FormBuilder, private toastr: ToastrService, private service: CommonService) { 

    this.packagingForm = this.fb.group({
        PackageSize: [null, [Validators.required]],
        UnitOfMeasurement: [null, [Validators.required]],
        PurchaseInvoiceValue: [null, [Validators.required]],
        PurchaseTaxableValue: [null, [Validators.required]],
        PurchaseCGST: [null, [Validators.required]],
        PurchaseSGST: [null, [Validators.required]],
        PurchaseIGST: [null, [Validators.required]],
        SellInvoiceValue: [null, [Validators.required]],
        SellTaxableValue: [null, [Validators.required]],
        SellCGST: [null, [Validators.required]],
        SellSGST: [null, [Validators.required]],
        SellIGST: [null, [Validators.required]]
    });
    this.loadPackageSizeList();

  }

  ngOnInit(): void {
  }

  loadPackageSizeList = async () => {
    this.packageSizeList = await this.service.get('/api/getPackageSizeList');
  }

  addPackage = () => {
    if(this.packagingForm.valid) {
      if(this.packagesList.value.some((e: any) => (this.PackageSize.value == e.PackageSize) && (this.UnitOfMeasurement.value == e.UnitOfMeasurement) )) {
              this.toastr.warning('Sorry. Selected Package size & Unit of Measuremnt already added in the List.');
      } else {
              this.packagesList.value.push(this.packagingForm.value);
              this.packagingForm.reset();
      }
    } else {
      this.toastr.error('Please fill all details of Package.')
    }
  }
  editPackageDetails = (x: any, index: number) => {
      this.packagesList.value.splice(index, 1);
      this.packagingForm.patchValue({
        PackageSize: x.PackageSize,
        UnitOfMeasurement: x.UnitOfMeasurement,
        PurchaseInvoiceValue: x.PurchaseInvoiceValue,
        PurchaseTaxableValue: x.PurchaseTaxableValue,
        PurchaseCGST: x.PurchaseCGST,
        PurchaseSGST: x.PurchaseSGST,
        PurchaseIGST: x.PurchaseIGST,
        SellInvoiceValue: x.SellInvoiceValue,
        SellTaxableValue: x.SellTaxableValue,
        SellCGST: x.SellCGST,
        SellSGST: x.SellSGST,
        SellIGST: x.SellIGST
      })
  }
  removePackage = (index: number) => {
      this.packagesList.value.splice(index, 1);
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




  get PackageSize(): any {
    return this.packagingForm.get('PackageSize');
  }
  get UnitOfMeasurement(): any {
    return this.packagingForm.get('UnitOfMeasurement');
  }
  get packagesList(): any {
    return this.ItemDetailsForm.get('packagesList');
  }
  get TaxRate(): any {
    return this.ItemDetailsForm.get('TaxRate')
  }
  get PurchaseInvoiceValue(): any {
    return this.packagingForm.get('PurchaseInvoiceValue')
  }
  get PurchaseTaxableValue(): any {
    return this.packagingForm.get('PurchaseTaxableValue')
  }
  get PurchaseCGST(): any {
    return this.packagingForm.get('PurchaseCGST')
  }
  get PurchaseSGST(): any {
    return this.packagingForm.get('PurchaseSGST')
  }
  get PurchaseIGST(): any {
    return this.packagingForm.get('PurchaseIGST')
  }
  get SellInvoiceValue(): any {
    return this.packagingForm.get('SellInvoiceValue')
  }
  get SellTaxableValue(): any {
    return this.packagingForm.get('SellTaxableValue')
  }
  get SellCGST(): any {
    return this.packagingForm.get('SellCGST')
  }
  get SellSGST(): any {
    return this.packagingForm.get('SellSGST')
  }
  get SellIGST(): any {
    return this.packagingForm.get('SellIGST')
  }

}
