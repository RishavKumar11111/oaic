import { ToastrService } from 'ngx-toastr';
import { Component, OnInit } from '@angular/core';

import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-add-item',
  templateUrl: './add-item.component.html',
  styleUrls: ['./add-item.component.css']
})
export class AddItemComponent implements OnInit {


    ItemDetailsForm: FormGroup;
  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService,
    private fb: FormBuilder
    ) { 
        this.layoutService.setBreadcrumb('Item / Add New Item');
        this.ItemDetailsForm = this.fb.group({
            Implement: ['', [Validators.required]],
            Make: ['', [Validators.required]],
            Model: ['', [Validators.required]],
            DivisionID: ['', [Validators.required]],
            HSN: ['', [Validators.required]],
            UnitOfMeasurement: ['', [Validators.required]],
            Taxability: ['Taxable', [Validators.required]],
            TaxRate: ['12', [Validators.required]],
            PurchaseInvoiceValue: ['', [Validators.required]],
            PurchaseTaxableValue: ['0', [Validators.required]],
            PurchaseCGST: ['0', [Validators.required]],
            PurchaseSGST: ['0', [Validators.required]],
            PurchaseIGST: ['0', [Validators.required]],
            PurchaseSGSTOnePercent: ['0', [Validators.required]],
            PurchaseCGSTOnePercent: ['0', [Validators.required]],
            SellInvoiceValue: ['', [Validators.required]],
            SellTaxableValue: ['0', [Validators.required]],
            SellCGST: ['0', [Validators.required]],
            SellSGST: ['0', [Validators.required]],
            SellIGST: ['0', [Validators.required]],
            packagesList: this.fb.array([])
        });
    }

  ngOnInit(): void {
  }


  loadingData = false;
  first_box = true;


  addItem = async() => {
      try {

          if(this.ItemDetailsForm.valid) {
              await this.service.post(`/admin/addItem`, this.ItemDetailsForm.value);
              this.toastr.success('New ITEM added successfully');
              this.ItemDetailsForm.patchValue({
                    Implement: '',
                    Make: '',
                    Model: '',
                    DivisionID: '',
                    HSN: '',
                    UnitOfMeasurement: '',
                    Taxability: 'Taxable',
                    TaxRate: '12',
                    PurchaseInvoiceValue: '',
                    PurchaseTaxableValue: '',
                    PurchaseCGST: '',
                    PurchaseSGST: '',
                    PurchaseIGST: '',
                    PurchaseSGSTOnePercent: '',
                    PurchaseCGSTOnePercent: '',
                    SellInvoiceValue: '',
                    SellTaxableValue: '',
                    SellCGST: '',
                    SellSGST: '',
                    SellIGST: '',
                    packagesList: []
              });
          } else {
            this.toastr.error('Please fill all required fields first');
          }
      } catch (e) {
          this.toastr.error('Sorry. Server problem. Plaese try again.');
          console.error(e);
      }
  }
  proceed = () => {
    
    if(!this.ItemDetailsForm.get('PurchaseInvoiceValue')?.value) {
      this.ItemDetailsForm.get('PurchaseInvoiceValue')?.setValue(0);
      this.ItemDetailsForm.get('PurchaseTaxableValue')?.setValue(0);
      this.ItemDetailsForm.get('PurchaseCGST')?.setValue(0);
      this.ItemDetailsForm.get('PurchaseSGST')?.setValue(0);
      this.ItemDetailsForm.get('PurchaseIGST')?.setValue(0);
      this.ItemDetailsForm.get('PurchaseSGSTOnePercent')?.setValue(0);
      this.ItemDetailsForm.get('PurchaseCGSTOnePercent')?.setValue(0);
    }
    if(!this.ItemDetailsForm.get('SellInvoiceValue')?.value) {
      this.ItemDetailsForm.get('SellInvoiceValue')?.setValue(0);
      this.ItemDetailsForm.get('SellTaxableValue')?.setValue(0);
      this.ItemDetailsForm.get('SellCGST')?.setValue(0);
      this.ItemDetailsForm.get('SellSGST')?.setValue(0);
      this.ItemDetailsForm.get('SellIGST')?.setValue(0);
    }
    
  }





}
