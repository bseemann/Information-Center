require 'minitest/autorun'

class ExpaRdSyncTest < Minitest::Test
  def setup
    xp = EXPA.setup()
    xp.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
  end

  def teardown
    ExpaPerson.all.each do |person|
      person.destroy
    end
    ExpaApplication.all.each do |application|
      application.destroy
    end
  end

  def test_insert_new_register_at_db
    assert(ExpaPerson.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaPerson.all.count.to_s)

    params = {'per_page' => 1}
    person = EXPA::Peoples.list_by_param(params)[0]
    xp_sync = ExpaRdSync.new
    xp_sync.update_db_peoples(person)

    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)
  end

  def test_update_fields_that_are_already_on_db
    assert(ExpaPerson.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaPerson.all.count.to_s)

    params = {'per_page' => 2}
    people = EXPA::Peoples.list_by_param(params)
    person = people[0]
    another_person = people[1]

    xp_sync = ExpaRdSync.new
    xp_sync.update_db_peoples(person)
    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)

    xp_sync.update_db_peoples(person)
    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)

    same_person = person.clone
    same_person.full_name = person.full_name + ' test'

    xp_sync.update_db_peoples(person)
    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)

    xp_sync.update_db_peoples(another_person)
    assert(ExpaPerson.all.count == 1, 'DB should have only 2 registers, but it has ' + ExpaPerson.all.count.to_s)
  end

  def test_insert_every_application_from_person_at_db
    assert(ExpaPerson.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaPerson.all.count.to_s)
    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)

    params = {'per_page' => 1, 'filters[status]' => 'realized'}
    person = EXPA::Peoples.list_by_param(params)[0]
    applications = EXPA::Peoples.get_applications(person.id)

    xp_sync = ExpaRdSync.new
    xp_sync.update_db_peoples(person)

    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)
    if applications.count > 0
      assert(ExpaApplication.all.count == applications.count && applications.count > 0, 'DB should have ' + applications.count.to_s + ' registers , but it has ' + ExpaApplication.all.count.to_s)
    else
      assert(ExpaApplication.all.count == applications.count && applications.count > 0, 'DB should have more than 0 (zero) registers , but it has ' + ExpaApplication.all.count.to_s)
    end
  end
end
