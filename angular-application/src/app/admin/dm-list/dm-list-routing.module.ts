import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DmListComponent } from './dm-list/dm-list.component';

const routes: Routes = [
  {
    path: '',
    component: DmListComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DmListRoutingModule { }
