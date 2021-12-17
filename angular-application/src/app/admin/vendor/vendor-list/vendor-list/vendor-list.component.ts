import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';


@Component({
  selector: 'app-vendor-list',
  templateUrl: './vendor-list.component.html',
  styleUrls: ['./vendor-list.component.css']
})
export class VendorListComponent implements OnInit {

    selectedVendorID: string = '';
  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
    ) { 
          this.layoutService.setBreadcrumb('Vendor / Update Vendors Details');
          this.loadAllDistricts();
          this.loadDlList();
          this.goto1stPage();
    }

  ngOnInit(): void {
  }





  loadingData = true;
  button_value = 'Submit';
  add_dealer_div = false;
  assigned_item_list: any = [];
  district_list: any = [];
  dlList: any = [];
  allDealerList: any;
  dist: any = '';
  page1: boolean = true;
  dd: any;
  Data: any;
  page2: boolean = false;
  page3: boolean = false;
  page4: boolean = false;

  dl_id: any;
  bussiness: any = {};
  removeDL: any = {};
  searchByDlName: string = '';

  // ======================== LOAD ALL DISTRICT, DEALER LIST START ==========================

  loadAllDistricts = async () => {
        this.district_list = await this.service.get('/admin/getAllDistricts');
        this.loadingData = false;
  }
  loadDlList = async() => {
      this.dlList = [];
      this.loadingData = true;
      this.dlList = await this.service.get('/admin/getAllDlList');
      this.loadingData = false;
      this.allDealerList = this.dlList;
  }
  loadDistWiseDealers = async() => {
      try {
          if (this.dist != null) {
              this.dlList = await this.service.get('/admin/getDistWiseDealerList?dist_id=' + this.dist.dist_id);
          } else {
              this.dlList = this.allDealerList;
          }
      } catch (e) {}
  }

  // ======================== LOAD ALL DISTRICT, DEALER LIST ENDS ==========================

  // ======================== VIEW DEALER DETAIL START ==========================

  showDlDetail = async(x: any) => {
      try {
          this.page1 = false;
          this.loadingData = true;
          this.dd = await this.service.get('/admin/getDlAllDetailByDlId?VendorID=' + x.VendorID);
          this.Data = this.dd;
          this.loadingData = false;
          this.page2 = true;
      } catch (e) {
          console.error(e);
      }
  }

  // ======================== VIEW DEALER DETAIL ENDS ==========================

  // ======================== EDIT DEALER PART START ==========================

  editDlDetail = async(x: any) => {
      try {
          this.page1 = false;
          this.loadingData = true;
          this.selectedVendorID = x.VendorID;
          this.loadingData = false;
          this.page3 = true;

      } catch (e) {
          console.error(e);
      }
  }
  // ======================== MANAGE ADD ITEMS ENDS ==========================

  // ======================== LOAD ALL PAGES 1ST, 2ND, 3RD ENDS ==========================

  goto1stPage = () => {
      this.page1 = true;
      this.page2 = false;
      this.page3 = false;
      this.page4 = false;
      this.loadDlList();
  }
  goto3rdPage = () => {
      this.page1 = false;
      this.page2 = false;
      this.page3 = true;
      this.page4 = false;
  }


  showRemoveDealerModal = (x: any) => {
      this.removeDL = x;
  }
  removeDealer = async() => {
      try {
          const data =  { VendorID: this.removeDL.VendorID };
          await this.service.post(`/admin/removeDealer`, data);
          this.toastr.success('Vendor removed successfully.');
          this.loadDlList();
      } catch (e) {
          this.toastr.error('Sorry. Enable to remove vendor. Plaese try again.');
          console.error(e);
      }
  }

    exportToExcel = function (tableIdSeed: any) {
        // var exportHref = Excel.tableToExcel(tableIdSeed, 'Approved');
        // $timeout(function () { location.href = exportHref; }, 100); // trigger download
    }



}
