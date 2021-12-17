import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DeliverGenerateInvoiceComponent } from './deliver-generate-invoice/deliver-generate-invoice.component'

const routes: Routes = [
  {
    path: '',
    component: DeliverGenerateInvoiceComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DeliverGenerateInvoiceRoutingModule { }
