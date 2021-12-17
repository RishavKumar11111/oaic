import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

declare const document: any

@Component({
  selector: 'app-approve-vendor',
  templateUrl: './approve-vendor.component.html',
  styleUrls: ['./approve-vendor.component.css']
})
export class ApproveVendorComponent implements OnInit {


  selectedVendorID: string = '';
  constructor(
    private layoutService: LayoutService,
    private serviceService: CommonService,
    private toastr: ToastrService) { 
    this.layoutService.setBreadcrumb('Vendor / Approve Vendor');
    this.loadDlList();
    this.goto1stPage();
    }

  ngOnInit(): void {
  }







  loadingData: boolean = true;

  allDealerList: any = [];
  Data: any = {};
  page3: boolean = false;
  page1: boolean = false;
  page2: boolean = false;
  page4: boolean = false;
  dd: any;

  bussiness: any = {};
  MSMECertificate: any;
  SSIUnitRegistrationCertificate: any;
  service: any = {};

  loadDlList = async() => {
      this.loadingData = true;
      this.allDealerList = await this.serviceService.get('/admin/getAllAppliedDealerList');
      this.loadingData = false;
  }

  // ======================== LOAD ALL DISTRICT, DEALER LIST ENDS ==========================

  // ======================== VIEW DEALER DETAIL START ==========================

  showDlDetail = async(x: any) => {
      try {
          this.page1 = false;
          this.loadingData = true;
          this.dd = await this.serviceService.get('/admin/getDlAllDetailByDlId?VendorID=' + x.VendorID);
          this.Data = this.dd;
          this.loadingData = false;
          this.page2 = true;
      } catch (e) {
          console.error(e);
      }
  }

  // ======================== VIEW DEALER DETAIL ENDS ==========================

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

  // ======================== LOAD ALL PAGES 1ST, 2ND, 3RD ENDS ==========================

  // ======================== FINAL SUBMIT START ==========================

  approve = async() => {
      try {
          const selectedItems = this.allDealerList.filter((e: any) => e.selected ).map((x: any) => x.VendorID);
          await this.serviceService.post(`/admin/approvDealers`, selectedItems)
          this.toastr.success('Selected Vendors approved successufully.');
          this.loadDlList();
      } catch (e) {
          this.toastr.error('Server problem. Please try again.');
          console.error(e);
      }
  }

  reject = async() => {
      try {
          const selectedItems = this.allDealerList.filter((e: any) => e.selected ).map((x: any) => x.VendorID);
          await this.serviceService.post(`/admin/rejectDealers`, selectedItems);
          this.toastr.success('Selected Vendors rejected successufully.');
          this.loadDlList();
      } catch (e) {
          window.alert('Server problem. Please try again.');
          console.error(e);
      }
  }

  editVendorDetails = async (x: any) => {
      try {
          this.page1 = false;
          this.selectedVendorID = x.VendorID;
          this.page3 = true;
      } catch (e) {
          console.error(e);
      }
  }
  // ======================== FINAL SUBMIT START ==========================










}
