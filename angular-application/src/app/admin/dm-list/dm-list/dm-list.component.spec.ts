import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { DmListComponent } from './dm-list.component';

describe('DmListComponent', () => {
  let component: DmListComponent;
  let fixture: ComponentFixture<DmListComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DmListComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DmListComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
