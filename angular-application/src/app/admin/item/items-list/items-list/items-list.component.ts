import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';


@Component({
  selector: 'app-items-list',
  templateUrl: './items-list.component.html',
  styleUrls: ['./items-list.component.css']
})
export class ItemsListComponent implements OnInit {

  ItemDetailsForm: FormGroup;
  searchByImplement: string = '';
  searchByMake: string = '';
  searchByModel: string = '';

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService,
    private fb: FormBuilder
    ) { 
      this.layoutService.setBreadcrumb('Item / Update Items Details');
      this.loadItemList();
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



  loadingData = true;
  first_box = true;
  update_detail = false;
  item: any = {};
  itemList: any = [];
  originalItem: any = {};

  

  loadItemList = async() => {
      this.itemList = [];
      this.loadingData = true;
      this.itemList = await this.service.get('/admin/getAllItemList');
      this.loadingData = false;
  }
  showRemoveItemModal = (x: any) => {
      this.selectFormFields(x);
  }
  showItemDetail = (x: any) => {
      this.selectFormFields(x);
  }
  showUpdateItem = (x: any) => {
      this.item = x;
      this.first_box = false;
      this.update_detail = true;
      this.item = x;
      this.originalItem = {
          Implement: x.Implement,
          Make: x.Make,
          Model: x.Model
      }
      this.selectFormFields(x);
  }
  
  back = () => {
      this.update_detail = false;
      this.first_box = true;
  }
  proceed = () => {
      this.update();
  }
  update = async() => {
      try {
          const updateData = this.ItemDetailsForm.value;
          await this.service.post(`/admin/updateItemDetail`, { originalItem: this.originalItem, updateData: updateData });
          this.loadItemList();
          this.toastr.success('Successfully Updated Item Details')
          this.back();
      } catch (e) {
          this.toastr.error('Sorry. Server problem. Plaese try again.');
          console.error(e);
      }
  }
  removeItem = async() => {
      try {
          let removeItem = {
              Implement: this.ItemDetailsForm.value['Implement'],
              Make: this.ItemDetailsForm.value['Make'],
              Model: this.ItemDetailsForm.value['Model']
          }
          await this.service.post(`/admin/removeItem`, removeItem);
          this.loadItemList();
          this.toastr.success('Successfully Item removed.');
      } catch (e) {
          this.toastr.error('Sorry, Enable to remove, Server problem. Plaese try again.');
          console.error(e);
      }
  }

  selectFormFields = async (x: any) => {
    try {
        this.ItemDetailsForm.patchValue({
            Implement: x.Implement,
            Make: x.Make,
            Model: x.Model,
            DivisionID: x.DivisionID,
            HSN: x.HSN,
            UnitOfMeasurement: x.UnitOfMeasurement,
            Taxability: x.Taxability,
            TaxRate: x.TaxRate,
            PurchaseInvoiceValue: x.PurchaseInvoiceValue,
            PurchaseTaxableValue: x.PurchaseTaxableValue,
            PurchaseCGST: x.PurchaseCGST,
            PurchaseSGST: x.PurchaseSGST,
            PurchaseIGST: x.PurchaseIGST,
            PurchaseSGSTOnePercent: x.PurchaseSGSTOnePercent,
            PurchaseCGSTOnePercent: x.PurchaseCGSTOnePercent,
            SellInvoiceValue: x.SellInvoiceValue,
            SellTaxableValue: x.SellTaxableValue,
            SellCGST: x.SellCGST,
            SellSGST: x.SellSGST,
            SellIGST: x.SellIGST
        });
        const response = await this.service.post('/api/getPackagesList', { 
            Implement: x.Implement,
            Make: x.Make,
            Model: x.Model,
            DivisionID: x.DivisionID });
        this.packagesList.value = [];
        response.forEach((e: any) => {
            this.packagesList.value.push(e);
        })
    } catch(e) {
        console.error(e);
        this.toastr.error('Network Problem, try again');
    }
  }


  
  get packagesList(): any {
    return this.ItemDetailsForm.get('packagesList');
  }

}
