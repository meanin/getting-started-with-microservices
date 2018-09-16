using System;
using Microsoft.AspNetCore.Mvc;

namespace ScaffoldedWebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HelloWorldController : ControllerBase
    {
        [HttpGet]
        public ActionResult<string> Get()
        {
            return $"Greetings from Hello World Controller on a {Environment.GetEnvironmentVariable("HOSTNAME")} Kubernetes POD!";
        }
    }
}
