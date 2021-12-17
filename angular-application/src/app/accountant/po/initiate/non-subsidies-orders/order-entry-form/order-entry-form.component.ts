import { ToastrService } from 'ngx-toastr';
import { Component, OnInit, EventEmitter, Output, Input } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-order-entry-form',
  templateUrl: './order-entry-form.component.html',
  styleUrls: ['./order-entry-form.component.css']
})
export class OrderEntryFormComponent implements OnInit {

  divisionList: any = [];
  implementList: any = [];
  makeList: any = [];
  modelList: any = [];
  packageSizeList: any = [];
  packageUnitList: any = [];
  vendorsList: any = [];
  CustomerList: any = [];
  nonSubsidyData: any = {
    DivisionID: '',
    Implement: '',
    Make: '',
    Model: '',
    Quantity: '',
    UnitOfMeasurement: '',
    PackageSize: '',
    PackageUnitOfMeasurement: '',
    PackageQuantity: ''
  };
  modelDetails: any = {};
  customerDetailsNgModel: any = '';

  vendorDetails: any = '';
  orderReferenceNo: any = '';
  packageDetails: any = {};
  @Output() addOrder = new EventEmitter<any>();
  @Input() orderList: any;
  @Input() customerDetails: any = '';
  @Input() vendorID: any;
  
  constructor(private service: CommonService, private toastr: ToastrService) { 
    this.loadDivisionList();
    this.loadVendorsList();
    this.loadCustomerList();
    this.loadPackageSizeList();
  }

  ngOnInit(): void {
  }



  loadPackagePrice = async () => {
      if(this.nonSubsidyData.Model) {
        const data = {
            DivisionID: this.nonSubsidyData.DivisionID,
            Implement: this.nonSubsidyData.Implement,
            Make: this.nonSubsidyData.Make,
            Model: this.nonSubsidyData.Model,
            PackageSize: this.nonSubsidyData.PackageSize,
            UnitOfMeasurement: this.nonSubsidyData.PackageUnitOfMeasurement
        };
        const response = await this.service.post(`/api/getPackagePrice`, data);        
        if(response) {

                this.packageDetails = response;
                this.calculatePackageQuantity();

        } else {
            this.toastr.error('Sorry the Price of that Package is not added.');
        }
        
      } else {
        // this.nonSubsidyData.PackageSize = '';
        // this.toastr.error("Select model First");
      }
  };
  loadPackageSizeList = async () => {
    //   this.packageSizeList = await this.service.get('/api/getPackageSizeList');
  }
  loadDivisionList = async () => {
      try{
          const response = await this.service.get('/accountant/getDivisionList');
          this.divisionList = response;
          this.nonSubsidyData.DivisionID = '';
          this.nonSubsidyData.Implement = '';
          this.nonSubsidyData.Make = '';
          this.nonSubsidyData.Model = '';
      } catch(e) {
          console.error(e);
      }
  }
  loadVendorsList = async () => {
      try{
          const response = await this.service.get('/accountant/getDistrictWiseVendorList');
          this.vendorsList = response;
          
      } catch(e) {
          console.error(e);
      }
  }

  loadCustomerList = async () => {
    try{
        const response = await this.service.get('/accountant/getDistrictWiseCustomerList');
        this.CustomerList = response;
    } catch(e) {
        console.error(e);
    }
}

  loadImplementList = async () => {
      try{
          const response = await this.service.get(`/accountant/getImplementList?DivisionID=${this.nonSubsidyData.DivisionID}`);
          this.implementList = response.map((e: any) => e.Implement);
          if(this.implementList.length == 1) {
              this.nonSubsidyData.Implement = this.implementList[0];
              this.loadMakeList();
          } else {
                this.nonSubsidyData.Implement = '';
                this.nonSubsidyData.Make = '';
                this.nonSubsidyData.Model = '';
                this.nonSubsidyData.PackageSize = '';
                this.makeList = [];
                this.modelList = [];
                this.packageSizeList = [];
                this.nonSubsidyData.PackageUnitOfMeasurement = '';
                this.packageUnitList = [];
          }
          
      } catch(e) {
          console.error(e);
      }
  }    
  loadMakeList = async () => {
      try{
          const data = {
              DivisionID: this.nonSubsidyData.DivisionID,
              Implement: this.nonSubsidyData.Implement
          }
          const response = await this.service.post(`/accountant/getMakeList`, data);
          this.makeList = response.map((e: any) => e.Make);
          if(this.makeList.length == 1) {
              this.nonSubsidyData.Make = this.makeList[0];
              this.loadModelList();
          } else {
            this.nonSubsidyData.Make = '';
            this.nonSubsidyData.Model = '';
            this.nonSubsidyData.PackageSize = '';
            this.nonSubsidyData.PackageUnitOfMeasurement = '';
            this.modelList = [];
            this.packageSizeList = [];
            this.packageUnitList = [];
        }
          
      } catch(e) {
          console.error(e);
      }
  }    
  loadModelList = async () => {
      try{
          const data = {
              DivisionID: this.nonSubsidyData.DivisionID,
              Implement: this.nonSubsidyData.Implement,
              Make: this.nonSubsidyData.Make
          }
          const response = await this.service.post(`/accountant/getModelList`, data);
          this.modelList = response.map((e: any) => e.Model);
          if(this.modelList.length == 1) {
              this.nonSubsidyData.Model = this.modelList[0];
              this.loadModelDetails();
          } else {
            this.nonSubsidyData.Model = '';
            this.nonSubsidyData.PackageSize = '';
            this.nonSubsidyData.PackageUnitOfMeasurement = '';
            this.packageSizeList = [];
            this.packageUnitList = [];
        }
      } catch(e) {
          console.error(e);
      }
  }    
  loadModelDetails = async () => {
      try{
          const data = {
              DivisionID: this.nonSubsidyData.DivisionID,
              Implement: this.nonSubsidyData.Implement,
              Make: this.nonSubsidyData.Make,
              Model: this.nonSubsidyData.Model
          }
          const response = await this.service.post(`/accountant/getModelDetails`, data);
          this.modelDetails = response.modelDetails;
          this.packageSizeList = response.packageList;
          this.nonSubsidyData.PackageUnitOfMeasurement = '';
          this.packageUnitList = [];
          const quantity = this.nonSubsidyData.Quantity ? this.nonSubsidyData.Quantity : 1;
          this.modelDetails.TotalPurchaseTaxableValue = (this.modelDetails.PurchaseTaxableValue * quantity).toFixed(2);
          this.modelDetails.TotalPurchaseInvoiceValue = (this.modelDetails.PurchaseInvoiceValue * quantity).toFixed(2);
          this.modelDetails.TotalPurchaseCGST = (this.modelDetails.PurchaseCGST * quantity).toFixed(2);
          this.modelDetails.TotalPurchaseSGST = (this.modelDetails.PurchaseSGST * quantity).toFixed(2);
          this.nonSubsidyData.UnitOfMeasurement = this.modelDetails.UnitOfMeasurement;
          
      } catch(e) {
          console.error(e);
      }
  }
  loadPackageUnits = async () => {
    try{
        const data = {
            DivisionID: this.nonSubsidyData.DivisionID,
            Implement: this.nonSubsidyData.Implement,
            Make: this.nonSubsidyData.Make,
            Model: this.nonSubsidyData.Model,
            PackageSize: this.nonSubsidyData.PackageSize
        }
        const response = await this.service.post(`/accountant/getPackageUnits`, data);
        this.packageUnitList = response;
        if(this.packageUnitList.length == 1) {
            this.nonSubsidyData.PackageUnitOfMeasurement = this.packageUnitList[0].UnitOfMeasurement;
            this.loadPackagePrice();
        } else {
            this.nonSubsidyData.PackageUnitOfMeasurement = '';
        }
    } catch(e) {
        console.error(e);
    }
  }





  shwPurchaseOrderForNonSubsidy = async () => {
      this.modelDetails.Quantity = this.nonSubsidyData.Quantity;
      this.modelDetails.VendorID = this.nonSubsidyData.VendorID;
      this.modelDetails.TotalSellTaxableValue = (this.modelDetails.SellTaxableValue * this.modelDetails.Quantity).toFixed(2);
      this.modelDetails.TotalSellCGST = (this.modelDetails.SellCGST * this.modelDetails.Quantity).toFixed(2);
      this.modelDetails.TotalSellSGST = (this.modelDetails.SellCGST * this.modelDetails.Quantity).toFixed(2);
      this.modelDetails.TotalSellInvoiceValue = (this.modelDetails.SellInvoiceValue * this.modelDetails.Quantity).toFixed(2);
      this.modelDetails.VendorID = this.vendorDetails.VendorID;
      this.modelDetails.CustomerID = this.customerDetailsNgModel.CustomerID;
      this.modelDetails.PackageSize = this.nonSubsidyData.PackageSize;
      this.modelDetails.PackageUnitOfMeasurement = this.nonSubsidyData.PackageUnitOfMeasurement;
      this.modelDetails.PackageQuantity = this.nonSubsidyData.PackageQuantity | 0;
      this.modelDetails.DivisionName = this.divisionList[this.divisionList.findIndex((e: any) => e.DivisionID == this.nonSubsidyData.DivisionID)].DivisionName;
    //   this.modelDetails.DeliveredQuantity = 0;
    //   this.modelDetails.PendingQuantity = this.nonSubsidyData.Quantity;
      this.orderList.value.push(this.modelDetails)
        this.nonSubsidyData = {
            DivisionID: '',
            Implement: '',
            Make: '',
            Model: '',
            Quantity: '',
            UnitOfMeasurement: '',
            PackageSize: '',
            PackageUnitOfMeasurement: '',
            PackageQuantity: ''
        };
        this.implementList = [];
        this.makeList = [];
        this.modelList = [];
        this.packageSizeList = [];
        this.packageUnitList = [];
        this.modelDetails = {};
  }
  calculatePackageQuantity = () => {
            const totalQuantity = this.nonSubsidyData.Quantity ? this.nonSubsidyData.Quantity : 1;
            const packateSize = this.nonSubsidyData.PackageSize;
            const unitOfMeasurement = this.nonSubsidyData.UnitOfMeasurement;
            const packateUnitOfMeasurement = this.nonSubsidyData.PackageUnitOfMeasurement;
            let finalUnit = 1;

            if(unitOfMeasurement == packateUnitOfMeasurement) {
                finalUnit = 1;
            } else if(unitOfMeasurement == 'Kilograms' && packateUnitOfMeasurement == 'Gram') {
                finalUnit = 1000;
            } else if(unitOfMeasurement == 'Metric Ton' && packateUnitOfMeasurement == 'Gram') {
                finalUnit = 1000000;
            } else if(unitOfMeasurement == 'Metric Ton' && packateUnitOfMeasurement == 'Kilograms') {
                finalUnit = 1000;
            } else if(unitOfMeasurement == 'Tonnes' && packateUnitOfMeasurement == 'Gram') {
                finalUnit = 1000000;
            } else if(unitOfMeasurement == 'Tonnes' && packateUnitOfMeasurement == 'Kilograms') {
                finalUnit = 1000;
            } else if(unitOfMeasurement == 'Liter' && packateUnitOfMeasurement == 'Mililiter') {
                finalUnit = 1000;
            } else {
                this.toastr.error('Selected unit not Mapped');
            }

            const quantity = ( totalQuantity * finalUnit ) / packateSize;
            this.nonSubsidyData.PackageQuantity = quantity;
            const isDividable = ( totalQuantity * finalUnit ) % packateSize;
            if(isDividable == 0) {
                this.calculateItemWiseTax();
            } else {
                this.toastr.error('Sorry, Please enter valid Quantity')
            }
  }
  calculateItemQuantity = () => {
      if(this.nonSubsidyData.PackageUnitOfMeasurement) {
            this.calculatePackageQuantity();
      } else {
            this.calculateItemWiseTax();
      }
  }
  calculateItemWiseTax = () => {
        const quantity = this.nonSubsidyData.PackageQuantity ? this.nonSubsidyData.PackageQuantity : this.nonSubsidyData.Quantity ? this.nonSubsidyData.Quantity : 1;
        const PurchaseTaxableValue = this.nonSubsidyData.PackageQuantity ? this.packageDetails.PurchaseTaxableValue : this.modelDetails.PurchaseTaxableValue;
        const PurchaseCGST = this.nonSubsidyData.PackageQuantity ? this.packageDetails.PurchaseCGST : this.modelDetails.PurchaseCGST;
        const PurchaseSGST = this.nonSubsidyData.PackageQuantity ? this.packageDetails.PurchaseSGST : this.modelDetails.PurchaseSGST;
        const PurchaseInvoiceValue = this.nonSubsidyData.PackageQuantity ? this.packageDetails.PurchaseInvoiceValue : this.modelDetails.PurchaseInvoiceValue;
    
        this.modelDetails.PurchaseTaxableValue = PurchaseTaxableValue;
        this.modelDetails.PurchaseCGST = PurchaseCGST;
        this.modelDetails.PurchaseSGST = PurchaseSGST;
        this.modelDetails.PurchaseInvoiceValue = PurchaseInvoiceValue;
        this.modelDetails.TotalPurchaseTaxableValue = ( PurchaseTaxableValue * quantity ).toFixed(2);
        this.modelDetails.RatePerUnit = (this.modelDetails.TotalPurchaseTaxableValue / this.nonSubsidyData.Quantity).toFixed(2);
        this.modelDetails.TotalPurchaseCGST = ( PurchaseCGST * quantity ).toFixed(2);
        this.modelDetails.TotalPurchaseSGST = ( PurchaseSGST * quantity ).toFixed(2);
        this.modelDetails.TotalPurchaseInvoiceValue = ( PurchaseInvoiceValue * quantity ).toFixed(2);
    }


  get orderListLength(): number {
    return this.orderList.value.length;
  }

  selectVenorID = () => {
      this.vendorID.setValue(this.vendorDetails.VendorID);
  }
  selectCustomerDetails = () => {
      this.customerDetails.setValue({CustomerName: this.customerDetailsNgModel.LegalCustomerName,
        OrderReferenceNo: '',
        CustomerMobileNumber: this.customerDetailsNgModel.ContactNumber,
        CustomerEmailID: this.customerDetailsNgModel.EmailID,
        CustomerGSTN: this.customerDetailsNgModel.GSTN,
    })    
  }

}
