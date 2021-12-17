import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PartPaymentComponent } from './part-payment/part-payment.component'

const routes: Routes = [
  {
    path: '',
    component: PartPaymentComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PartPaymentRoutingModule { }
