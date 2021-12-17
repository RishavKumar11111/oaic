import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ApproveVendorComponent } from './approve-vendor/approve-vendor.component';

const routes: Routes = [
  {
    path: '',
    component: ApproveVendorComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ApproveVendorRoutingModule { }
