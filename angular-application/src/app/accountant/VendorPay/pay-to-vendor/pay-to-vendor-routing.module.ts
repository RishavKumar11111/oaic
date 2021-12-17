import { Component, NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PayToVendorComponent } from './pay-to-vendor/pay-to-vendor.component'

const routes: Routes = [
  {
    path: '',
    component: PayToVendorComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PayToVendorRoutingModule { }
