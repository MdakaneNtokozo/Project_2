using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Project_2_API.Models;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Project_2_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FamilyMembersController : ControllerBase
    {
        Project2DatabaseContext context;
        PasswordHasher<String> pHasher;

        public FamilyMembersController(Project2DatabaseContext _context)
        {
            context = _context;
            pHasher = new PasswordHasher<String>();
        }

        [HttpGet]
        [Route("getFamilyMembers")]
        public async Task<Object> GetFamilyMembers()
        {
            return Ok(await context.FamilyMembers.ToListAsync());
        }

        [HttpGet]
        [Route("getFamilyMemberById/{id}")]
        public async Task<Object> GetFamilyMemberById(int id)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var member = members.Find(m => m.FamilyMemberId == id);

            if (member != null)
            {
                return Ok(member);
            }
            else
            {
                return NotFound("This family member cannot be found");
            }
        }

        [HttpPost]
        [Route("updateFamilyMember")]
        public async Task<Object> UpdateFamilyMember(FamilyMember member)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var memberFound = members.Find(m => m.FamilyMemberId == member.FamilyMemberId);

            if (memberFound != null)
            {
                memberFound = member;

                context.FamilyMembers.Update(memberFound);
                await context.SaveChangesAsync();

                return Ok("Family member has been updated");
            }
            else
            {
                return NotFound("This family member cannot be found");
            }
        }

        [HttpDelete]
        [Route("deleteFamilyMember")]
        public async Task<Object> DeleteFamilyMember(FamilyMember member)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var memberFound = members.Find(m => m.FamilyMemberId == member.FamilyMemberId);

            if (memberFound != null)
            {
                memberFound = member;

                context.FamilyMembers.Remove(memberFound);
                await context.SaveChangesAsync();

                return Ok("Family member has been deleted");
            }
            else
            {
                return NotFound("This family member cannot be found");
            }
        }


        [HttpGet]
        [Route("login")]
        public async Task<Object> Login(String email, String password)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var member = members.Find(m => m.FamilyMemberEmail == email);

            if (member != null)
            {
                var result = pHasher.VerifyHashedPassword(member.FamilyMemberEmail, member.FamilyMemberPassword, password);
                if (result == PasswordVerificationResult.Success)
                {
                    return Ok("Family member has successfully logged in");
                }
                else
                {
                    return BadRequest("Incorrect details hav been entered");
                }
            }
            else
            {
                return NotFound("This email does not exist");
            }
        }

        [HttpGet]
        [Route("signup")]
        public async Task<Object> SignUp(FamilyMember member)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var memberfound = members.Find(m => m.FamilyMemberEmail == member.FamilyMemberEmail);

            if (memberfound != null)
            {
                int lastIdx = 0;

                if (members.Count > 0)
                {
                    lastIdx = members.ElementAt(members.Count - 1).FamilyMemberId;
                }

                member.FamilyMemberId = lastIdx;
                member.FamilyMemberPassword = pHasher.HashPassword(member.FamilyMemberEmail, member.FamilyMemberPassword);

                context.FamilyMembers.Add(member);
                await context.SaveChangesAsync();

                return Ok("Family member has successfully signed up");
            }
            else
            {
                return BadRequest("This email is already in use");
            }
        }
    }
}
