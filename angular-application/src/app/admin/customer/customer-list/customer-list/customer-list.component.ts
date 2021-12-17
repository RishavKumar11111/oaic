import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';


@Component({
  selector: 'app-customer-list',
  templateUrl: './customer-list.component.html',
  styleUrls: ['./customer-list.component.css']
})
export class CustomerListComponent implements OnInit {
  customerList: any = [];
  removeCustomer: any = {};
  updateDetailPage: boolean = false;
  selectedCustomerID: string = '';
  page1: boolean = true;
  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
  ) { 
    console.log("Calledddd");
    
    this.layoutService.setBreadcrumb('Customer / Update Customer Details');
    this.loadCustomerList();
  }

  ngOnInit(): void {
  }


  loadCustomerList = async () => {
    try{
      this.customerList = await this.service.get(`/admin/getCustomerList`);
    } catch (e) {
      this.toastr.error(`Network problem`)
    }
  }

  showRemoveCustomerModal = (x: any) => {
    this.removeCustomer = x;
    // console.log(this.removeCustomer);
    
  }

  removeCustomerDetails = async() => {
    try {
        const data =  { CustomerID: this.removeCustomer.CustomerID };
        await this.service.post(`/admin/removeCustomer`, data);
        this.toastr.success('Customer removed successfully.');
        this.loadCustomerList();
    } catch (e) {
        this.toastr.error('Sorry. Enable to remove customer. Plaese try again.');
        console.error(e);
    }
}


  updateCusomerDetails = async (x: any) => {
    this.selectedCustomerID = x.CustomerID;
    this.updateDetailPage = true;
    this.page1 = false;
  }
  back = async () => {
    this.updateDetailPage = false;
    this.page1 = true;
  }

  eventAfterUpdateDone = () => {
    this.loadCustomerList();
    this.back();
  }

  exportToExcel = function (tableIdSeed: any) {
    // var exportHref = Excel.tableToExcel(tableIdSeed, 'Approved');
    // $timeout(function () { location.href = exportHref; }, 100); // trigger download
  } 

}
