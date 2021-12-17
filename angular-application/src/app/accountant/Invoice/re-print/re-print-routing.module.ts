import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { RePrintComponent } from './re-print/re-print.component'

const routes: Routes = [
  {
    path: '',
    component: RePrintComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class RePrintRoutingModule { }
