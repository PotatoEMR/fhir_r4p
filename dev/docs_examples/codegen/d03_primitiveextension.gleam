import fhir/r4p/complex_types
import fhir/r4p/resources
import fhir/r4p/valuesets
import gleam/json
import gleam/list
import gleam/option.{Some}

pub fn main() {
  let assert Ok(name) = json.parse(name_json, complex_types.humanname_decoder())
  let assert Some(valuesets.NameuseOfficial) = name.use_.value
  let assert Some(family) = name.family.value
  assert family == "van Hentenryck"
  let assert [given] = name.given
  let assert Some(given_value) = given.value
  assert given_value == "Karen"
  let assert Ok(e1) =
    list.find(name.family.ext, fn(ext) {
      ext.url == "http://hl7.org/fhir/StructureDefinition/humanname-own-prefix"
    })
  let assert complex_types.ExtSimple(complex_types.ExtensionValueString(
    own_prefix,
  )) = e1.ext
  assert own_prefix == "van"
  let assert Ok(e2) =
    list.find(name.family.ext, fn(ext) {
      ext.url == "http://hl7.org/fhir/StructureDefinition/humanname-own-name"
    })
  let assert complex_types.ExtSimple(complex_types.ExtensionValueString(
    own_name,
  )) = e2.ext
  assert own_name == "Hentenryck"

  let assert Ok(qr) =
    json.parse(
      questionnaireresponse_json,
      resources.questionnaireresponse_decoder(),
    )
  let assert Ok(display) =
    list.find(qr.questionnaire.ext, fn(ext) {
      ext.url == "http://hl7.org/fhir/StructureDefinition/display"
    })
  let assert complex_types.ExtSimple(complex_types.ExtensionValueString(
    display_value,
  )) = display.ext
  assert display_value == "Lifelines"
}

const name_json = "
  {
    \"use\" : \"official\",
    \"family\" : \"van Hentenryck\",
    \"_family\" : {
      \"extension\" : [{
        \"url\" : \"http://hl7.org/fhir/StructureDefinition/humanname-own-prefix\",
        \"valueString\" : \"van\"
      }, {
        \"url\" : \"http://hl7.org/fhir/StructureDefinition/humanname-own-name\",
        \"valueString\" : \"Hentenryck\"
      }]
    },
    \"given\" : [\"Karen\"]
  }
"

const questionnaireresponse_json = "
  {
    \"resourceType\" : \"QuestionnaireResponse\",
    \"status\" : \"completed\",
    \"authored\" : \"2024-01-01T00:00:00Z\",
    \"_questionnaire\": {
      \"extension\": [
        {
          \"url\": \"http://hl7.org/fhir/StructureDefinition/display\",
          \"valueString\": \"Lifelines\"
        }
      ]
    }
  }
"
