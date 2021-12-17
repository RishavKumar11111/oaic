import { CommonService } from 'src/app/services/common.service';

import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-acc-list',
  templateUrl: './acc-list.component.html',
  styleUrls: ['./acc-list.component.css']
})
export class AccListComponent implements OnInit {

  constructor(
    private layoutService: LayoutService,
    private service: CommonService, 
    private toastr: ToastrService
    ) { 
      this.layoutService.setBreadcrumb('Update Accountants Details');
      this.loadAccList();
  }

  ngOnInit(): void {
  }



  loadingData: boolean = true;
  selectedItem: any = {};
  accList: any  = [];

  // ======================== LOAD ACCOUNTANT LIST START ==========================

  loadAccList = async() => {
      this.accList = [];
      this.loadingData = true;
      this.accList = await this.service.get('/admin/getAccList');
      this.loadingData = false;
  }

  // ======================== LOAD ACCOUNTANT LIST ENDS ==========================

  // ======================== SHOW MODIFY MODAL START ==========================

  showModifyModal = (x: any) => {
      this.selectedItem = x;
      this.selectedItem.acc_mobile_no = parseFloat(x.acc_mobile_no);
  }

  // ======================== SHOW MODIFY MODAL ENDS ==========================

  // ======================== UPDATE ACCOUNTANT DETAIL START ==========================

  modifyAccDetail = async() => {
      try {
          let data = {
              acc_name: this.selectedItem.acc_name,
              acc_mobile_no: this.selectedItem.acc_mobile_no,
              acc_address: this.selectedItem.acc_address
          }
          await this.service.post(`/admin/modifyAccDetail`, { u_data: data, acc_id: this.selectedItem.acc_id, DistrictID: this.selectedItem.dist_id  });
          this.toastr.success('Accountant detail modified successfully.');
          this.loadAccList();
      } catch (e) {
          this.toastr.error('Server problem. Please try again.');
          console.error(e);
      }
  }

  // ======================== UPDATE ACCOUNTANT DETAIL ENDS ==========================







}
