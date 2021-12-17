import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ApprovedPaymentListComponent } from './approved-payment-list.component';

const routes: Routes = [
  {
    path: '',
    component: ApprovedPaymentListComponent 
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ApprovedPaymentListRoutingModule { }
