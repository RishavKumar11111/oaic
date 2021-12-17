import { ToastrService } from 'ngx-toastr';
import { Component, OnInit } from '@angular/core';

import { LayoutService } from 'src/app/services/layout/layout.service';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-dm-list',
  templateUrl: './dm-list.component.html',
  styleUrls: ['./dm-list.component.css']
})
export class DmListComponent implements OnInit {

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService) { 
    this.layoutService.setBreadcrumb('Update District Managers Details');
    this.loadDMList();
  }

  ngOnInit(): void {
  }




    loadingData: boolean = true;
    selectedItem: any = {};
    EmailID: string = '';

    s_dist_name: any;
    s_dm_user_id: any;
    s_dm_name: any;
    s_dm_address: any;
    s_dm_id: any;
    s_dm_mobile_no: any;
    dmList: any = [];
    BankName: any;
    BranchName: any;
    AccountNumber: any;
    IFSCCode: any;
    // ======================== LOAD ALL DM LIST START ==========================

    loadDMList = async () => {
        try{
            this.dmList = [];
            this.loadingData = true;
            this.dmList = await this.service.get('/admin/getDMList');
            this.loadingData = false;
        } catch (e) {
            console.log(e);
        }
    }

    // ======================== LOAD ALL DM LIST ENDS ==========================

    // ======================== MODIFY MODAL START ==========================

    showModifyModal = (x: any) => {
        this.selectedItem = x;
        this.s_dist_name = x.dist_name;
        this.s_dm_user_id = x.dm_id;
        this.s_dm_name = x.dm_name;
        this.EmailID = x.EmailID;
        this.s_dm_address = x.dm_address;
        this.s_dm_id = x.dm_id;
        this.s_dm_mobile_no = parseFloat(x.dm_mobile_no);
        
        this.BankName = x.BankName;
        this.BranchName = x.BranchName;
        this.AccountNumber = parseFloat(x.AccountNumber);
        this.IFSCCode = x.IFSCCode;
    }

    // ======================== MODIFY MODAL ENDS ==========================

    // ======================== UPDATE DM DETAIL START ==========================

    modifyDMDetail = async() => {
        try {
            let m_data = {
                name: this.s_dm_name,
                mobile_no: this.s_dm_mobile_no,
                address: this.s_dm_address,
                EmailID: this.EmailID,
                BankName: this.BankName,
                BranchName: this.BranchName,
                AccountNumber: this.AccountNumber,
                IFSCCode: this.IFSCCode
            }
            await this.service.post(`/admin/modifyDMDetail`, { u_data: m_data, dm_id: this.s_dm_id, DistrictID: this.selectedItem.dist_id });
            this.toastr.success('DM detail updated successfully.');
            this.loadDMList();
        } catch (e) {
            console.error(e);
            this.toastr.error(`Error`);
        }
    }

    // ======================== UPDATE DM DETAIL START ==========================








}
