import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ReceivePaymentsComponent } from './receive-payments/receive-payments.component';

const routes: Routes = [
  {
    path: '',
    component: ReceivePaymentsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ReceivePaymentsRoutingModule { }
