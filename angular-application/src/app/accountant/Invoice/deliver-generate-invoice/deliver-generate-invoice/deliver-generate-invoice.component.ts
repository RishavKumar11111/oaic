import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { CommonService } from 'src/app/services/common.service';
import { ToastrService } from 'ngx-toastr';
import { FormControl, FormBuilder, Validators } from '@angular/forms';

@Component({
  selector: 'app-deliver-generate-invoice',
  templateUrl: './deliver-generate-invoice.component.html',
  styleUrls: ['./deliver-generate-invoice.component.css']
})
export class DeliverGenerateInvoiceComponent implements OnInit {

  POType: FormControl = new FormControl('NonSubsidy');
  @ViewChild("printInvoice") printInvoice!: ElementRef;
  
  x: any = {};
  dist_id: any;
  showTable: any = true;
  show_print_page: any = false;
  loader: any = false;
  fin_year: any;
  header: any;
  AccountantDetails: any;
  DMDetails: any;
  indent_no: any;
  indent_date: any;
  invoice_no: any;
  invoice_date: any;
  mrr_no: any;
  mrr_date: any;
  permitno: any;
  remark: any;
  expected_delivery_date: any;
  items: any = [];


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
  orderList: any = [];
  unitOfMeasurementList: any = [];
  customerDetails: FormControl = new FormControl('');



  availableQuantity: number = 0;
  AddCustomerForm: any;
  invoicedata: any = [];
  clicked= false;

  constructor(
    private formBuilder: FormBuilder,
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
  ) {
    this.layoutService.setBreadcrumb('Invoice / Deliver & Generate Invoice');
    this.dist_id = layoutService.getDistrictID();
    
    this.loadDivisionList();
    this.loadCustomerList();

    this.AddCustomerForm = this.formBuilder.group({
      legalname: ['',[Validators.required]],
      tradename: ['',[Validators.required]],
      contactnumber: ['',[Validators.required]],
      email: ['',[Validators.required]],
      constitutionofbusiness: ['',[Validators.required]]
    });


  }


  ngOnInit(): void {
  }

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadList();
  }

  loadList = async () => {
    this.loader = true;
    this.show_print_page = false;
    let response = await this.service.get('/accountant/getItemsForDeliverToCustomer?dist_id=' + this.dist_id + '&fin_year=' + this.fin_year);
    this.items = response;
    this.loader = false;
    this.showTable = true;

  }


  AddCustomerDetails = async() => {
    try {
        if(this.AddCustomerForm.valid) {
            await this.service.post(`/accountant/addCustomerDetails`, this.AddCustomerForm.value);
            this.toastr.success('Customer Details added successfully');
            this.AddCustomerForm.reset();
            this.loadCustomerList()
        } else {
          this.toastr.error('Please fill all required fields first');
        }
    } catch (e) {
        this.toastr.error('Sorry. Server problem. Plaese try again.');
        console.error(e);
    }
  
  
  }

  showDetailes = (x: any) => {
    this.x = x;
  }

  subTotal: any = 0;

  showDelivery = async (x: any) => {
    this.permitno = x.permit_no;
    x.invoiceValue = x.p_invoice_value;
    this.subTotal = parseInt(this.subTotal) + parseInt(x.invoiceValue);
    this.x = x;
    // let response = await this.service.get('/accountant/getPermitDetail?permit_no=' + x.permit_no)
    // this.indent_no = response.indent_no;
    // this.indent_date = response.indent_date;
    // this.invoice_no = response.invoice_no;
    // this.invoice_date = response.invoice_date;
    // this.mrr_no = response.mrr_id;
    // this.mrr_date = response.mrr_date;

  }

  showInvoice = () => {
    if (this.POType.value !== "NonSubsidy") {
      this.orderList = [];
      this.orderList.push(this.x);
    }
    if(this.orderList.length > 0) {
      this.showTable = false;
      this.show_print_page = true;
    } else {
      this.toastr.error('Add Minimum One Item')
    }
    
  }

  deliverPreview = async () => {
    try {
      this.showTable = false;
      this.loader = true;
      this.orderList.forEach((e: any) => e.POType = this.POType.value)
      const response = await this.service.post(`/accountant/addCustomerInvoice`, this.orderList);
      this.invoicedata = response;
      setTimeout(() => {
        this.printInvoice.nativeElement.click();
        this.loadList();
        this.orderList = [];
        this.resetForm()
        this.show_print_page = false;
      })
    } catch (e: any) {
      console.error(e);
      this.toastr.error('Server Problem. Try Again!!');
    } finally {
      this.clicked = false;
      this.loader = false;
    }
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
  loadDivisionList = async () => {
      try{
          const response = await this.service.get('/accountant/getStockDivisionList');
          this.divisionList = response;
          this.nonSubsidyData.DivisionID = '';
          this.nonSubsidyData.Implement = '';
          this.nonSubsidyData.Make = '';
          this.nonSubsidyData.Model = '';
          this.nonSubsidyData.UnitOfMeasurement = '';
          this.unitOfMeasurementList = [];
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
          const response = await this.service.get(`/accountant/getStockImplementList?DivisionID=${this.nonSubsidyData.DivisionID}`);
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
                this.nonSubsidyData.UnitOfMeasurement = '';
                this.packageUnitList = [];
                this.unitOfMeasurementList = [];
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
          const response = await this.service.post(`/accountant/getStockMakeList`, data);
          this.makeList = response.map((e: any) => e.Make);
          if(this.makeList.length == 1) {
              this.nonSubsidyData.Make = this.makeList[0];
              this.loadModelList();
          } else {
            this.nonSubsidyData.Make = '';
            this.nonSubsidyData.Model = '';
            this.nonSubsidyData.PackageSize = '';
            this.nonSubsidyData.PackageUnitOfMeasurement = '';
            this.nonSubsidyData.UnitOfMeasurement = '';
            this.modelList = [];
            this.packageSizeList = [];
            this.packageUnitList = [];
            this.unitOfMeasurementList = [];
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
          const response = await this.service.post(`/accountant/getStockModelList`, data);
          this.modelList = response.map((e: any) => e.Model);
          if(this.modelList.length == 1) {
              this.nonSubsidyData.Model = this.modelList[0];
              this.loadModelUnitOfMeasurementList();
          } else {
            this.nonSubsidyData.Model = '';
            this.nonSubsidyData.PackageSize = '';
            this.nonSubsidyData.PackageUnitOfMeasurement = '';
            this.nonSubsidyData.UnitOfMeasurement = '';
            this.packageSizeList = [];
            this.packageUnitList = [];
            this.unitOfMeasurementList = [];
        }
      } catch(e) {
          console.error(e);
      }
  }
  loadModelUnitOfMeasurementList = async () => {
    try{
      const data = {
          DivisionID: this.nonSubsidyData.DivisionID,
          Implement: this.nonSubsidyData.Implement,
          Make: this.nonSubsidyData.Make,
          Model: this.nonSubsidyData.Model
      }
      const response = await this.service.post(`/accountant/getStockUnitOfMeasurementList`, data);
      this.unitOfMeasurementList = response.map((e: any) => e.UnitOfMeasurement);
      if(this.unitOfMeasurementList.length == 1) {
          this.nonSubsidyData.UnitOfMeasurement = this.unitOfMeasurementList[0];
          this.loadModelDetails();
      } else {
        this.nonSubsidyData.UnitOfMeasurement = '';
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
              Model: this.nonSubsidyData.Model,
              UnitOfMeasurement: this.nonSubsidyData.UnitOfMeasurement
          }
          const response = await this.service.post(`/accountant/getStockModelDetails`, data);
          this.modelDetails = response.modelDetails;
          this.packageSizeList = response.packageList;

          const addedQuantity = this.orderList.filter((e: any) => 
          e.DivisionID == this.nonSubsidyData.DivisionID && 
          e.Implement == this.nonSubsidyData.Implement &&
          e.Make == this.nonSubsidyData.Make &&
          e.Model == this.nonSubsidyData.Model &&
          e.UnitOfMeasurement == this.nonSubsidyData.UnitOfMeasurement
          ).reduce((accumlator: any, current: any) => accumlator + current.ItemQuantity, 0)
          
          this.availableQuantity = this.modelDetails.AvailableQuantity - addedQuantity;
          
          this.nonSubsidyData.Quantity = this.availableQuantity;
          this.packageUnitList = [];
          const quantity = this.nonSubsidyData.Quantity ? this.nonSubsidyData.Quantity : 1;
          this.modelDetails.TotalSellTaxableValue = (this.modelDetails.SellTaxableValue * quantity).toFixed(2);
          this.modelDetails.TotalSellInvoiceValue = (this.modelDetails.SellInvoiceValue * quantity).toFixed(2);
          this.modelDetails.TotalSellCGST = (this.modelDetails.SellCGST * quantity).toFixed(2);
          this.modelDetails.TotalSellSGST = (this.modelDetails.SellSGST * quantity).toFixed(2);
          this.modelDetails.TotalSellIGST = (this.modelDetails.SellIGST * quantity).toFixed(2);
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
            UnitOfMeasurement: this.nonSubsidyData.UnitOfMeasurement,
            PackageSize: this.nonSubsidyData.PackageSize
        }        
        const response = await this.service.post(`/accountant/getStockPackageUnits`, data);
        this.packageUnitList = response;
        if(this.packageUnitList.length == 1) {
            this.nonSubsidyData.PackageUnitOfMeasurement = this.packageUnitList[0].PackageUnitOfMeasurement;
            this.loadPackagePrice();
        } else {
            this.nonSubsidyData.PackageUnitOfMeasurement = '';
        }
    } catch(e) {
        console.error(e);
    }
  }


  shwPurchaseOrderForNonSubsidy = async () => {

    if (this.customerDetailsNgModel != "" && this.nonSubsidyData.DivisionID != "") {
      if (this.nonSubsidyData.Quantity > this.availableQuantity) {
        this.toastr.error(`Quantity exceed. Please add quantity within ${this.availableQuantity}`)
      } else {
        this.availableQuantity = this.availableQuantity - this.nonSubsidyData.Quantity
        this.modelDetails.ItemQuantity = this.nonSubsidyData.Quantity
        this.modelDetails.VendorID = this.nonSubsidyData.VendorID
        this.modelDetails.CustomerID = this.customerDetailsNgModel.CustomerID
        this.modelDetails.PackageSize = this.nonSubsidyData.PackageSize
        this.modelDetails.PackageUnitOfMeasurement = this.nonSubsidyData.PackageUnitOfMeasurement
        this.modelDetails.PackageQuantity = this.nonSubsidyData.PackageQuantity | 0
        this.modelDetails.DivisionName = this.divisionList[this.divisionList.findIndex((e: any) => e.DivisionID == this.nonSubsidyData.DivisionID)].DivisionName
        this.orderList.push(this.modelDetails)

        this.resetForm()
      }
    }
    else {
      this.toastr.error('Please enter all the required fields.');
    }

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
        const SellTaxableValue = this.nonSubsidyData.PackageQuantity ? this.packageDetails.SellTaxableValue : this.modelDetails.SellTaxableValue;
        const SellCGST = this.nonSubsidyData.PackageQuantity ? this.packageDetails.SellSGST : this.modelDetails.SellSGST;
        const SellSGST = this.nonSubsidyData.PackageQuantity ? this.packageDetails.SellSGST : this.modelDetails.SellSGST;
        const SellInvoiceValue = this.nonSubsidyData.PackageQuantity ? this.packageDetails.SellInvoiceValue : this.modelDetails.SellInvoiceValue;
    
        this.modelDetails.SellTaxableValue = SellTaxableValue;        
        this.modelDetails.TotalSellTaxableValue = ( SellTaxableValue * quantity ).toFixed(2);
        this.modelDetails.RatePerUnit = (this.modelDetails.TotalSellTaxableValue / this.nonSubsidyData.Quantity).toFixed(2);
        this.modelDetails.TotalSellCGST = ( SellCGST * quantity ).toFixed(2);
        this.modelDetails.TotalSellSGST = ( SellSGST * quantity ).toFixed(2);
        this.modelDetails.TotalSellInvoiceValue = ( SellInvoiceValue * quantity ).toFixed(2);
    }


  get orderListLength(): number {
    return this.orderList.value.length;
  }

  selectCustomerDetails = () => {
      this.customerDetails.setValue({CustomerName: this.customerDetailsNgModel.LegalCustomerName,
        OrderReferenceNo: '',
        CustomerMobileNumber: this.customerDetailsNgModel.ContactNumber,
        CustomerEmailID: this.customerDetailsNgModel.EmailID,
        CustomerGSTN: this.customerDetailsNgModel.GSTN,
    })    
  }

  removeOrder = (index: number) => {
    this.orderList.splice(index, 1);

  }
  resetForm = () => {
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

}



// SELECT a.*,
// d."DivisionName"
// FROM "CustomerInvoiceMaster" a
//  JOIN "DivisionMaster" d ON d."DivisionID"::text = c."DivisionID"::text;






//  SELECT COALESCE(sum(a."ItemQuantity"), 0::bigint) AS "ReceivedQuantity",
//  COALESCE(sum(b."DeliveredQuantity"::integer), 0::bigint) AS "DeliveredQuantity",
//  COALESCE(sum(a."ItemQuantity"), 0::bigint) - COALESCE(sum(b."DeliveredQuantity"::integer), 0::bigint) AS "AvailableQuantity",
//  a."DistrictID",
//  a."DivisionID",
//  a."DivisionName",
//  a."Implement",
//  a."Make",
//  a."Model",
//  a."UnitOfMeasurement",
//  a."PackageSize",
//  a."PackageUnitOfMeasurement"
// FROM "MRRViews" a
//   LEFT JOIN "CustomerInvoiceViews" b ON a."DivisionID"::text = b."DivisionID"::text AND a."DivisionName"::text = b."DivisionName"::text AND a."Implement"::text = b."Implement"::text AND a."Make"::text = b."Make"::text AND a."Model"::text = b."Model"::text AND a."PackageSize"::text = b."PackageSize"::text
// GROUP BY a."DistrictID", a."DivisionID", a."DivisionName", a."Implement", a."Make", a."Model", a."UnitOfMeasurement", a."PackageUnitOfMeasurement", a."PackageSize";