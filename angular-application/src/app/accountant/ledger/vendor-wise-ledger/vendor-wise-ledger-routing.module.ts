import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { VendorWiseComponent } from './vendor-wise/vendor-wise.component';

const routes: Routes = [
  {
    path:'',
    component: VendorWiseComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class VendorWiseLedgerRoutingModule { }
