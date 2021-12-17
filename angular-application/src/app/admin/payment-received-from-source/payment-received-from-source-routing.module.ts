import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PaymentReceiveComponent } from './payment-receive/payment-receive.component';

const routes: Routes = [
  {
    path: '',
    component: PaymentReceiveComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PaymentReceivedFromSourceRoutingModule { }
