import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { AccListComponent } from './acc-list.component';

describe('AccListComponent', () => {
  let component: AccListComponent;
  let fixture: ComponentFixture<AccListComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AccListComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AccListComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
