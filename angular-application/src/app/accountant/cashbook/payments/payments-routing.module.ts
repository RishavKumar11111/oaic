import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CashBookPaymentsComponent } from './cash-book-payments/cash-book-payments.component';

const routes: Routes = [
  {
    path: '',
    component: CashBookPaymentsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PaymentsRoutingModule { }
