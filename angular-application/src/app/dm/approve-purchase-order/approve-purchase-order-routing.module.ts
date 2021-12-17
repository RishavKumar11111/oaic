import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ApprovePurchaseOrderComponent } from './approve-purchase-order.component';

const routes: Routes = [
  {
    path: '',
    component: ApprovePurchaseOrderComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ApprovePurchaseOrderRoutingModule { }
